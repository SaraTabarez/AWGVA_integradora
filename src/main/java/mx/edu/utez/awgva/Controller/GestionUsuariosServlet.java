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
import java.util.List;

@WebServlet("/GestionUsuariosServlet")
public class GestionUsuariosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UsuarioDao dao = new UsuarioDao();
        List<Usuario> listaUsuarios = dao.findAll();

        request.setAttribute("listaUsuarios", listaUsuarios);
        request.getRequestDispatcher("gestion-usuarios.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}