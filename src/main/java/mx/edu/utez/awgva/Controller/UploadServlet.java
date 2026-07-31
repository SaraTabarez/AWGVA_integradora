package mx.edu.utez.awgva.Controller;

import mx.edu.utez.awgva.Model.SolicitudVisita;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "UploadServlet", urlPatterns = {"/UploadServlet"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class UploadServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "evidencias_reportes";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 1. Ruta de guardado física
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;

        File fileSaveDir = new File(uploadFilePath);
        if (!fileSaveDir.exists()) {
            fileSaveDir.mkdirs();
        }

        // 2. Obtener el índice de la solicitud enviada desde el formulario
        String indexParam = request.getParameter("solicitudIndex");

        // 3. Guardar las imágenes físicamente
        for (Part part : request.getParts()) {
            String fileName = getFileName(part);
            if (fileName != null && !fileName.isEmpty()) {
                part.write(uploadFilePath + File.separator + fileName);
            }
        }

        // 4. CAMBIAR EL ESTADO EN LA SESIÓN A "REPORTE_ENVIADO"
        if (indexParam != null && !indexParam.isEmpty()) {
            try {
                int index = Integer.parseInt(indexParam);
                HttpSession session = request.getSession();
                List<SolicitudVisita> listaSolicitudes = (List<SolicitudVisita>) session.getAttribute("listaSolicitudes");

                if (listaSolicitudes != null && index >= 0 && index < listaSolicitudes.size()) {
                    SolicitudVisita sol = listaSolicitudes.get(index);
                    sol.setEstado("REPORTE_ENVIADO");
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // 5. Redirigir a la vista de éxito
        response.sendRedirect("reporte-exito.jsp");
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}