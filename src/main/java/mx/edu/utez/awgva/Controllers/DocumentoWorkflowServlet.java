package mx.edu.utez.awgva.Controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import mx.edu.utez.awgva.Model.Documento;
import mx.edu.utez.awgva.Model.ExpedienteVisita;
import mx.edu.utez.awgva.Model.Usuario;
import mx.edu.utez.awgva.Service.DocumentoService;
import mx.edu.utez.awgva.Service.VisitaService;
import mx.edu.utez.awgva.Utils.FileValidationUtil;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;

@WebServlet(name = "DocumentoWorkflowServlet", value = "/documentos")
@MultipartConfig(fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10 * 1024 * 1024, maxRequestSize = 12 * 1024 * 1024)
public class DocumentoWorkflowServlet extends HttpServlet {
    private static final Set<String> EXTENSIONES = Set.of(".pdf", ".png", ".jpg", ".jpeg", ".webp");
    private DocumentoService documentoService;
    private VisitaService visitaService;
    private Path uploadRoot;

    @Override
    public void init() throws ServletException {
        documentoService = new DocumentoService();
        visitaService = new VisitaService();
        String configured = System.getenv("AWGVA_UPLOAD_DIR");
        Path base = configured == null || configured.isBlank()
                ? ((java.io.File) getServletContext().getAttribute("jakarta.servlet.context.tempdir")).toPath()
                : Path.of(configured);
        uploadRoot = base.resolve("documentos").toAbsolutePath().normalize();
        try { Files.createDirectories(uploadRoot); }
        catch (IOException exception) { throw new ServletException("No fue posible preparar los archivos.", exception); }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Usuario docente = (Usuario) request.getSession(false).getAttribute("usuario");
        Long visitaId;
        try { visitaId = Long.valueOf(request.getParameter("visitaId")); }
        catch (RuntimeException exception) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        ExpedienteVisita expediente = visitaService.buscarDelDocente(visitaId, docente.getIdUsuario());
        if (expediente == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        Path target = null;
        try {
            String tipo = documentoService.normalizarTipo(request.getParameter("tipoDocumento"));
            Part part = request.getPart("archivo");
            if (part == null || part.getSize() == 0) throw new IllegalArgumentException("Selecciona un archivo.");
            String original = nombreSeguro(part.getSubmittedFileName());
            String extension = extension(original);
            if (!EXTENSIONES.contains(extension)) throw new IllegalArgumentException("Formato no permitido.");

            target = uploadRoot.resolve(UUID.randomUUID() + extension).normalize();
            if (!target.startsWith(uploadRoot)) throw new IllegalArgumentException("Nombre no válido.");
            try (InputStream input = part.getInputStream()) {
                Files.copy(input, target, StandardCopyOption.REPLACE_EXISTING);
            }
            if (!FileValidationUtil.hasExpectedSignature(target, extension)) {
                throw new IllegalArgumentException("El contenido no coincide con la extensión.");
            }

            Documento anterior = documentoService.buscarPorVisitaYTipo(visitaId, tipo);
            Documento documento = new Documento(visitaId, tipo, target.toString(), original, part.getSize());
            if (!documentoService.guardar(documento)) {
                throw new IllegalStateException("No fue posible registrar el documento en Oracle.");
            }
            eliminarAnterior(anterior, target);
            response.sendRedirect(request.getContextPath() + "/detalle-solicitud?id=" + visitaId + "&subido=1");
        } catch (IllegalArgumentException | IllegalStateException exception) {
            if (target != null) Files.deleteIfExists(target);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            expediente.setDocumentos(documentoService.listarPorVisita(visitaId));
            request.setAttribute("expediente", expediente);
            request.setAttribute("error", exception.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/docente/detalle-solicitud.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect(request.getContextPath() + "/mis-solicitudes");
    }

    private String nombreSeguro(String submitted) {
        if (submitted == null || submitted.isBlank()) throw new IllegalArgumentException("Nombre no válido.");
        String value = submitted.replace('\\', '/');
        value = value.substring(value.lastIndexOf('/') + 1).trim();
        if (value.length() > 180) throw new IllegalArgumentException("El nombre del archivo es demasiado largo.");
        return value.replaceAll("[\\r\\n\\\"]", "_");
    }

    private String extension(String fileName) {
        int dot = fileName.lastIndexOf('.');
        return dot < 0 ? "" : fileName.substring(dot).toLowerCase(Locale.ROOT);
    }

    private void eliminarAnterior(Documento anterior, Path nuevo) {
        if (anterior == null || anterior.getRutaArchivo() == null) return;
        try {
            Path viejo = Path.of(anterior.getRutaArchivo()).toAbsolutePath().normalize();
            if (!viejo.equals(nuevo) && viejo.startsWith(uploadRoot)) Files.deleteIfExists(viejo);
        } catch (IOException | RuntimeException ignored) {
            // El registro nuevo ya quedó guardado; un archivo antiguo huérfano no invalida la operación.
        }
    }
}
