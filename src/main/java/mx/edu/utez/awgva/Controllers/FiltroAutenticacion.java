package mx.edu.utez.awgva.Controllers;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class FiltroAutenticacion extends HttpFilter {

    @Override
    protected void doFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = requestURI.substring(contextPath.length());
        HttpSession session = request.getSession(false);

        boolean loggedIn = (session != null && session.getAttribute("usuario") != null);

        // Rutas públicas que no requieren autenticación
        boolean isPublicPath = path.equals("/") ||
                path.equals("/login.jsp") ||
                path.equals("/login") ||
                path.equals("/logout") ||
                path.equals("/recuperar-contra.jsp") ||
                path.equals("/reset-password") ||
                path.startsWith("/assets/") ||
                path.startsWith("/Layout/") ||
                path.startsWith("/layout/") ||
                path.endsWith(".css") ||
                path.endsWith(".js") ||
                path.endsWith(".png") ||
                path.endsWith(".jpg") ||
                path.endsWith(".jpeg") ||
                path.endsWith(".gif") ||
                path.endsWith(".ico") ||
                path.endsWith(".html");

        if (loggedIn) {
            // Si está logueado y trata de acceder a login, redirigir al index
            if (path.equals("/") || path.equals("/login.jsp") || path.equals("/login") || path.equals("/recuperar-contra.jsp")) {
                response.sendRedirect(contextPath + "/index.jsp");
            } else {
                chain.doFilter(request, response);
            }
        } else {
            // Si no está logueado, permitir acceso solo a rutas públicas
            if (isPublicPath) {
                chain.doFilter(request, response);
            } else {
                response.sendRedirect(contextPath + "/login.jsp");
            }
        }
    }
}