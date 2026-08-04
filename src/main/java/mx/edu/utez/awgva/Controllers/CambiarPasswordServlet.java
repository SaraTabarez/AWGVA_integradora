package mx.edu.utez.awgva.Controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mx.edu.utez.awgva.Model.Usuario;
import mx.edu.utez.awgva.Service.UsuarioService;

import java.io.IOException;

@WebServlet(name = "CambiarPasswordServlet", value = "/cambiar-contrasena")
public class CambiarPasswordServlet extends HttpServlet {
    private UsuarioService usuarioService;

    @Override
    public void init() { usuarioService = new UsuarioService(); }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/cuenta/cambiar-contrasena.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Usuario usuario = (Usuario) request.getSession(false).getAttribute("usuario");
        String nueva = request.getParameter("nuevaPassword");
        if (nueva == null || !nueva.equals(request.getParameter("confirmacion"))) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            request.setAttribute("error", "La confirmación no coincide.");
            doGet(request, response);
            return;
        }
        try {
            if (!usuarioService.changePassword(usuario, request.getParameter("passwordActual"), nueva)) {
                throw new IllegalArgumentException("La contraseña actual no es correcta.");
            }
            request.setAttribute("mensaje", "Contraseña actualizada correctamente.");
        } catch (IllegalArgumentException exception) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            request.setAttribute("error", exception.getMessage());
        }
        doGet(request, response);
    }
}