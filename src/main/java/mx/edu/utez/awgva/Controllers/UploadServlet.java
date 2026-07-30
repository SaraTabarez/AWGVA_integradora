package mx.edu.utez.awgva.Controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import mx.edu.utez.awgva.Dao.DocumentoDao;
import mx.edu.utez.awgva.Model.Documento;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet(name = "UploadServlet", value = "/upload-servlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,     // 1 MB
        maxFileSize = 1024 * 1024 * 10,      // 10 MB
        maxRequestSize = 1024 * 1024 * 15   // 15 MB
)
public class UploadServlet extends HttpServlet {

    private DocumentoDao documentoDao;
    private static final String UPLOAD_DIR = "uploads";

    @Override
    public void init() throws ServletException {
        this.documentoDao = new DocumentoDao();
        // Crear directorio de uploads si no existe
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String visitaIdStr = request.getParameter("visitaId");
        String tipoDocumento = request.getParameter("tipoDocumento");

        if (visitaIdStr == null || visitaIdStr.isBlank() || tipoDocumento == null || tipoDocumento.isBlank()) {
            request.setAttribute("error", "Por favor, selecciona una visita y el tipo de documento.");
            request.getRequestDispatcher("subir-docs.jsp").forward(request, response);
            return;
        }

        Long visitaId = Long.parseLong(visitaIdStr);
        Part filePart = request.getPart("archivo");

        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("error", "Por favor, selecciona un archivo.");
            request.getRequestDispatcher("subir-docs.jsp").forward(request, response);
            return;
        }

        // Generar nombre único para el archivo
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String fileExtension = fileName.substring(fileName.lastIndexOf("."));
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;

        // Ruta donde se guardará el archivo
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        String filePath = uploadPath + File.separator + uniqueFileName;

        // Guardar archivo en disco
        filePart.write(filePath);

        // Guardar en base de datos
        Documento documento = new Documento();
        documento.setIdVisitaFk(visitaId);
        documento.setTipoDocumento(tipoDocumento);
        documento.setRutaArchivo(UPLOAD_DIR + File.separator + uniqueFileName);
        documento.setNombreArchivo(fileName);
        documento.setTamanoArchivo(filePart.getSize());

        boolean exito = documentoDao.guardarDocumento(documento);

        if (exito) {
            request.setAttribute("mensaje", "Documento subido exitosamente.");
            request.getRequestDispatcher("subir-docs.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Error al guardar el documento en la base de datos.");
            request.getRequestDispatcher("subir-docs.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("subir-docs.jsp");
    }
}