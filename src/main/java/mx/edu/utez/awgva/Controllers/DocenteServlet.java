package mx.edu.utez.awgva.Controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mx.edu.utez.awgva.Model.CatalogoCarreras;
import mx.edu.utez.awgva.Model.Empresa;
import mx.edu.utez.awgva.Model.ExpedienteVisita;
import mx.edu.utez.awgva.Model.GrupoVisita;
import mx.edu.utez.awgva.Model.Usuario;
import mx.edu.utez.awgva.Model.Visita;
import mx.edu.utez.awgva.Service.DocumentoService;
import mx.edu.utez.awgva.Service.VisitaService;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet(name = "DocenteServlet", urlPatterns = {
        "/mis-solicitudes", "/nueva-solicitud", "/detalle-solicitud",
        "/reportes-docente", "/historico-docente"
})
public class DocenteServlet extends HttpServlet {
    private VisitaService visitaService;
    private DocumentoService documentoService;

    @Override
    public void init() {
        visitaService = new VisitaService();
        documentoService = new DocumentoService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Usuario usuario = usuario(request);
        try {
            switch (request.getServletPath()) {
                case "/mis-solicitudes" -> {
                    request.setAttribute("solicitudes", visitaService.listarDelDocente(usuario.getIdUsuario()));
                    forward(request, response, "/WEB-INF/views/docente/solicitudes.jsp");
                }
                case "/nueva-solicitud" -> mostrarFormulario(request, response, usuario);
                case "/detalle-solicitud" -> {
                    ExpedienteVisita expediente = buscarPropio(request, usuario);
                    expediente.setDocumentos(documentoService.listarPorVisita(expediente.getIdVisita()));
                    request.setAttribute("expediente", expediente);
                    forward(request, response, "/WEB-INF/views/docente/detalle-solicitud.jsp");
                }
                case "/reportes-docente" -> {
                    request.setAttribute("solicitudes", visitaService.listarReportesDelDocente(usuario.getIdUsuario()));
                    forward(request, response, "/WEB-INF/views/docente/reportes.jsp");
                }
                case "/historico-docente" -> {
                    request.setAttribute("solicitudes", visitaService.listarHistoricoDocente(usuario.getIdUsuario()));
                    forward(request, response, "/WEB-INF/views/docente/historico.jsp");
                }
                default -> response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (IllegalArgumentException exception) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, exception.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!"/nueva-solicitud".equals(request.getServletPath())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }
        request.setCharacterEncoding("UTF-8");
        Usuario usuario = usuario(request);
        try {
            String carrera = required(request, "carrera", 180);
            if (!CatalogoCarreras.pertenece(usuario.getNombreDivision(), carrera)) {
                throw new IllegalArgumentException("La carrera no pertenece a tu división.");
            }
            LocalDate inicio = fecha(request, "fechaInicio");
            LocalDate fin = fecha(request, "fechaFin");
            if (fin.isBefore(inicio)) {
                throw new IllegalArgumentException("La fecha de término no puede ser anterior al inicio.");
            }
            int estudiantes = entero(request, "numeroEstudiantes", 1, 200);

            Visita visita = new Visita();
            visita.setIdUsuarioFk(usuario.getIdUsuario());
            visita.setIdDivisionFk(usuario.getIdDivisionFk());
            visita.setTituloVisita(required(request, "titulo", 180));
            visita.setAsignaturaAReforzar(required(request, "asignatura", 500));
            visita.setDocenteEncargado(usuario.getNombreCompleto());
            visita.setDocenteAcompanante(optional(request, "docenteAcompanante", 180));
            visita.setPropositoVisita(required(request, "proposito", 1000));
            visita.setFechaInicioVisita(inicio);
            visita.setFechaFinVisita(fin);
            visita.setEstado("PENDIENTE_DIRECTOR");

            Empresa empresa = new Empresa();
            empresa.setNombreEmpresa(required(request, "empresa", 180));
            empresa.setDireccion(required(request, "direccionEmpresa", 300));
            empresa.setTelefono(optional(request, "telefonoEmpresa", 30));
            empresa.setCorreo(optional(request, "correoEmpresa", 160));

            GrupoVisita grupo = new GrupoVisita();
            grupo.setProgramaEducativo(carrera);
            grupo.setSemestre(required(request, "semestre", 30));
            grupo.setNombreGrupo(required(request, "grupo", 50));
            grupo.setNumeroEstudiantes(estudiantes);

            if (!visitaService.crearVisitaCompleta(visita, empresa, grupo)) {
                throw new IllegalStateException("No fue posible guardar la solicitud en Oracle.");
            }
            response.sendRedirect(request.getContextPath() + "/mis-solicitudes?creada=1");
        } catch (IllegalArgumentException | IllegalStateException exception) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            request.setAttribute("error", exception.getMessage());
            mostrarFormulario(request, response, usuario);
        }
    }

    private void mostrarFormulario(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {
        request.setAttribute("carreras", CatalogoCarreras.deDivision(usuario.getNombreDivision()));
        forward(request, response, "/WEB-INF/views/docente/nueva-solicitud.jsp");
    }

    private ExpedienteVisita buscarPropio(HttpServletRequest request, Usuario usuario) {
        Long id = id(request.getParameter("id"));
        ExpedienteVisita expediente = visitaService.buscarDelDocente(id, usuario.getIdUsuario());
        if (expediente == null) throw new IllegalArgumentException("La solicitud no existe o no te pertenece.");
        return expediente;
    }

    private Usuario usuario(HttpServletRequest request) {
        return (Usuario) request.getSession(false).getAttribute("usuario");
    }

    private Long id(String value) {
        try { return Long.valueOf(value); }
        catch (RuntimeException exception) { throw new IllegalArgumentException("Identificador no válido."); }
    }

    private LocalDate fecha(HttpServletRequest request, String nombre) {
        try { return LocalDate.parse(required(request, nombre, 10)); }
        catch (DateTimeParseException exception) { throw new IllegalArgumentException("Fecha no válida."); }
    }

    private int entero(HttpServletRequest request, String nombre, int min, int max) {
        try {
            int value = Integer.parseInt(required(request, nombre, 4));
            if (value < min || value > max) throw new NumberFormatException();
            return value;
        } catch (NumberFormatException exception) {
            throw new IllegalArgumentException("Número de estudiantes no válido.");
        }
    }

    private String required(HttpServletRequest request, String nombre, int max) {
        String value = request.getParameter(nombre);
        if (value == null || value.isBlank() || value.trim().length() > max) {
            throw new IllegalArgumentException("Completa correctamente todos los campos obligatorios.");
        }
        return value.trim();
    }

    private String optional(HttpServletRequest request, String nombre, int max) {
        String value = request.getParameter(nombre);
        if (value == null) return "";
        if (value.trim().length() > max) throw new IllegalArgumentException("Uno de los campos es demasiado largo.");
        return value.trim();
    }

    private void forward(HttpServletRequest request, HttpServletResponse response, String jsp)
            throws ServletException, IOException {
        request.getRequestDispatcher(jsp).forward(request, response);
    }
}
