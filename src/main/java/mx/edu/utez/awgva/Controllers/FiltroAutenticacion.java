package mx.edu.utez.awgva.Controllers;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mx.edu.utez.awgva.Model.TipoRol;
import mx.edu.utez.awgva.Model.Usuario;
import mx.edu.utez.awgva.Utils.CsrfTokenUtil;

import java.io.IOException;
import java.util.Set;

/** Autenticación, CSRF y autorización por rol con denegación predeterminada. */
@WebFilter("/*")
public class FiltroAutenticacion extends HttpFilter {
    private static final Set<String> PUBLIC_PATHS = Set.of(
            "/", "/login.jsp", "/login", "/recuperar-contra.jsp", "/reset-password"
    );
    private static final Set<String> SHARED_PATHS = Set.of(
            "/inicio", "/index.jsp", "/logout", "/cambiar-contrasena", "/archivo"
    );
    private static final Set<String> DOCENTE_PATHS = Set.of(
            "/mis-solicitudes", "/nueva-solicitud", "/detalle-solicitud",
            "/reportes-docente", "/historico-docente", "/documentos"
    );
    private static final Set<String> ADMIN_PATHS = Set.of(
            "/GestionUsuariosServlet", "/RegistrarUsuarioServlet",
            "/ActualizarEstadoUsuarioServlet", "/gestion-usuarios.jsp", "/registrar-usuario.jsp"
    );

    @Override
    protected void doFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        headers(response);
        String contextPath = request.getContextPath();
        String path = request.getRequestURI().substring(contextPath.length());
        HttpSession session = request.getSession(false);
        Usuario usuario = session == null ? null : (Usuario) session.getAttribute("usuario");

        if (path.startsWith("/assets/") || "/favicon.ico".equals(path)) {
            chain.doFilter(request, response);
            return;
        }
        if (usuario == null) {
            if ("/recuperar-contra.jsp".equals(path)) {
                response.sendRedirect(contextPath + "/reset-password");
            } else if (PUBLIC_PATHS.contains(path)) {
                chain.doFilter(request, response);
            } else {
                response.sendRedirect(contextPath + "/login.jsp");
            }
            return;
        }
        if (PUBLIC_PATHS.contains(path)) {
            response.sendRedirect(contextPath + "/inicio");
            return;
        }

        TipoRol rol = usuario.getTipoRol().orElse(null);
        if (rol == null) {
            session.invalidate();
            response.sendRedirect(contextPath + "/login.jsp?error=rol");
            return;
        }
        if ("POST".equalsIgnoreCase(request.getMethod())
                && !CsrfTokenUtil.matches(session, request.getParameter("csrfToken"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "El formulario expiró. Recarga la página.");
            return;
        }
        if (autorizado(rol, path)) {
            chain.doFilter(request, response);
            return;
        }
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        request.setAttribute("rutaDenegada", path);
        request.getRequestDispatcher("/WEB-INF/views/error/403.jsp").forward(request, response);
    }

    private boolean autorizado(TipoRol rol, String path) {
        if (SHARED_PATHS.contains(path)) return true;
        if (DOCENTE_PATHS.contains(path)) return rol == TipoRol.DOCENTE;
        if (path.startsWith("/director/")) return rol == TipoRol.DIRECTOR;
        if (path.startsWith("/estadias/")) return rol == TipoRol.ESTADIAS;
        if (ADMIN_PATHS.contains(path)) return rol == TipoRol.ADMIN;
        return false;
    }

    private void headers(HttpServletResponse response) {
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("X-Frame-Options", "SAMEORIGIN");
        response.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
        response.setHeader("Permissions-Policy", "camera=(), microphone=(), geolocation=()");
        response.setHeader("Cache-Control", "no-store");
    }
}
