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

        boolean isPublicPath =
                path.equals("/") ||
                        path.equals("/login.jsp") ||
                        path.equals("/login") ||
                        path.equals("/recuperar-contra.jsp") ||
                        path.equals("/reset-password") ||
                        path.equals("/nueva-solicitud.jsp") ||
                        path.equals("/subir-docs.jsp") ||
                        path.equals("/index.jsp") ||
                        path.equals("/assets/") ||
                        path.startsWith("/assets/") ||
                        path.startsWith("/layout/") ||
                        path.startsWith("/uploads/") ||
                        path.endsWith(".css") ||
                        path.endsWith(".js") ||
                        path.endsWith(".png") ||
                        path.endsWith(".jpg") ||
                        path.endsWith(".jpeg") ||
                        path.endsWith(".gif") ||
                        path.endsWith(".ico");

        if (loggedIn) {
            if (path.equals("/") || path.equals("/login.jsp") || path.equals("/login") || path.equals("/recuperar-contra.jsp")) {
                response.sendRedirect(contextPath + "/index.jsp");
            } else {
                chain.doFilter(request, response);
            }
        } else {
            if (isPublicPath) {
                chain.doFilter(request, response);
            } else {
                response.sendRedirect(contextPath + "/login.jsp");
            }
        }
    }
}