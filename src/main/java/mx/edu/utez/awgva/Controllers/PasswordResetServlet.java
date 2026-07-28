package mx.edu.utez.awgva.Controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mx.edu.utez.awgva.Service.UsuarioService;

import java.io.IOException;
@WebServlet(name = "PasswordResetServlet", value = "reset-password")
public class PasswordResetServlet extends HttpServlet {

    private UsuarioService usuarioService;

    @Override
    public void init() throws ServletException {
        this.usuarioService = new UsuarioService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("solicitar".equals(action)) {
            handleSolicitarCodigo(request, response);
        } else if ("restablecer".equals(action)) {
            handleRestablecerPassword(request, response);
        } else {
            response.sendRedirect("recuperar-contra.jsp");
        }
    }

    private void handleSolicitarCodigo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String correo = request.getParameter("correo");
        if (correo == null || correo.isBlank()) {
            request.setAttribute("error", "Por favor, ingresa tu correo electrónico.");
            request.getRequestDispatcher("recuperar-contra.jsp").forward(request, response);
            return;
        }

        boolean enviado = usuarioService.generateAndSendResetCode(correo);

        if (enviado) {
            request.setAttribute("correo", correo);
            request.setAttribute("mensaje", "Se ha enviado un código de 6 dígitos a tu correo. Tiene 15 minutos de vigencia.");
            request.setAttribute("mostrarCodigoForm", true);
            request.getRequestDispatcher("recuperar-contra.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "No se encontró una cuenta con ese correo electrónico.");
            request.getRequestDispatcher("recuperar-contra.jsp").forward(request, response);
        }
    }

    private void handleRestablecerPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String codigo = request.getParameter("codigo");
        String nuevaPassword = request.getParameter("nuevaPassword");
        String confirmarPassword = request.getParameter("confirmarPassword");

        if (codigo == null || codigo.isBlank() ||
                nuevaPassword == null || nuevaPassword.isBlank() ||
                confirmarPassword == null || confirmarPassword.isBlank()) {
            request.setAttribute("error", "Por favor, completa todos los campos.");
            request.setAttribute("mostrarCodigoForm", true);
            request.getRequestDispatcher("recuperar-contra.jsp").forward(request, response);
            return;
        }

        if (!nuevaPassword.equals(confirmarPassword)) {
            request.setAttribute("error", "Las contraseñas no coinciden.");
            request.setAttribute("mostrarCodigoForm", true);
            request.getRequestDispatcher("recuperar-contra.jsp").forward(request, response);
            return;
        }

        if (nuevaPassword.length() < 6) {
            request.setAttribute("error", "La contraseña debe tener al menos 6 caracteres.");
            request.setAttribute("mostrarCodigoForm", true);
            request.getRequestDispatcher("recuperar-contra.jsp").forward(request, response);
            return;
        }

        boolean exito = usuarioService.resetPassword(codigo, nuevaPassword);

        if (exito) {
            request.setAttribute("mensaje", "Tu contraseña ha sido actualizada exitosamente. Ahora puedes iniciar sesión.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "El código es inválido o ha expirado. Solicita un nuevo código.");
            request.setAttribute("mostrarCodigoForm", false);
            request.getRequestDispatcher("recuperar-contra.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("recuperar-contra.jsp");
    }
}
