package mx.edu.utez.awgva.Controller;

import mx.edu.utez.awgva.Dao.UsuarioDao;
import mx.edu.utez.awgva.Model.Usuario;

// SE CAMBIÓ 'javax.servlet' POR 'jakarta.servlet'
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/RegistrarUsuarioServlet")
public class RegistrarUsuarioServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nombres = request.getParameter("nombres");
        String apellidoPaterno = request.getParameter("apellidoPaterno");
        String apellidoMaterno = request.getParameter("apellidoMaterno");
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");

        String idRolStr = request.getParameter("idRol");
        Long idRol = (idRolStr != null && !idRolStr.isEmpty()) ? Long.parseLong(idRolStr) : null;

        String idDivisionStr = request.getParameter("idDivision");
        Long idDivision = (idDivisionStr != null && !idDivisionStr.isEmpty()) ? Long.parseLong(idDivisionStr) : null;

        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setNombres(nombres);
        nuevoUsuario.setApellidoPaterno(apellidoPaterno);
        nuevoUsuario.setApellidoMaterno(apellidoMaterno);
        nuevoUsuario.setCorreo(correo);
        nuevoUsuario.setPassword(password); // Asigna el passwordHash internamente
        nuevoUsuario.setIdRolFk(idRol);
        nuevoUsuario.setIdDivisionFk(idDivision);

        UsuarioDao dao = new UsuarioDao();
        boolean guardado = dao.save(nuevoUsuario);

        if (guardado) {
            response.sendRedirect("GestionUsuariosServlet");
        } else {
            response.sendRedirect("registrar-usuario.jsp?error=1");
        }
    }
}