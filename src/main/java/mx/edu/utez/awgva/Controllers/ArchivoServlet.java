package mx.edu.utez.awgva.Controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mx.edu.utez.awgva.Model.Documento;
import mx.edu.utez.awgva.Model.TipoRol;
import mx.edu.utez.awgva.Model.Usuario;
import mx.edu.utez.awgva.Service.DocumentoService;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

@WebServlet(name = "ArchivoServlet", value = "/archivo")
public class ArchivoServlet extends HttpServlet {
    private DocumentoService documentoService;
    private Path allowedRoot;

    @Override
    public void init() throws ServletException {
        documentoService = new DocumentoService();
        String configured = System.getenv("AWGVA_UPLOAD_DIR");
        Path base = configured == null || configured.isBlank()
                ? ((java.io.File) getServletContext().getAttribute("jakarta.servlet.context.tempdir")).toPath()
                : Path.of(configured);
        allowedRoot = base.resolve("documentos").toAbsolutePath().normalize();
        try { Files.createDirectories(allowedRoot); }
        catch (IOException exception) { throw new ServletException(exception); }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long id;
        try { id = Long.valueOf(request.getParameter("id")); }
        catch (RuntimeException exception) { response.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }

        Documento documento = documentoService.buscarPorId(id);
        Usuario usuario = (Usuario) request.getSession(false).getAttribute("usuario");
        if (documento == null || !autorizado(usuario, documento)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        try {
            Path file = Path.of(documento.getRutaArchivo()).toAbsolutePath().normalize();
            Path realRoot = allowedRoot.toRealPath();
            Path realFile = file.toRealPath();
            if (!realFile.startsWith(realRoot) || !Files.isRegularFile(realFile)) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            String contentType = Files.probeContentType(realFile);
            response.setContentType(contentType == null ? "application/octet-stream" : contentType);
            response.setContentLengthLong(Files.size(realFile));
            String disposition = "1".equals(request.getParameter("descargar")) ? "attachment" : "inline";
            response.setHeader("Content-Disposition", disposition + "; filename=\""
                    + documento.getNombreArchivo().replace("\"", "_") + "\"");
            Files.copy(realFile, response.getOutputStream());
        } catch (IOException | RuntimeException exception) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private boolean autorizado(Usuario usuario, Documento documento) {
        if (usuario == null) return false;
        TipoRol rol = usuario.getTipoRol().orElse(null);
        if (rol == TipoRol.ADMIN || rol == TipoRol.ESTADIAS) return true;
        if (rol == TipoRol.DOCENTE) return usuario.getIdUsuario().equals(documento.getIdPropietario());
        return rol == TipoRol.DIRECTOR && usuario.getIdDivisionFk() != null
                && usuario.getIdDivisionFk().equals(documento.getIdDivision());
    }
}