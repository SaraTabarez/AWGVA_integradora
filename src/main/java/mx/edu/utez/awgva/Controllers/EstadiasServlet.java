package mx.edu.utez.awgva.Controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mx.edu.utez.awgva.Model.Documento;
import mx.edu.utez.awgva.Model.ExpedienteVisita;
import mx.edu.utez.awgva.Model.Usuario;
import mx.edu.utez.awgva.Service.DocumentoService;
import mx.edu.utez.awgva.Service.VisitaService;

import java.io.IOException;

@WebServlet(name = "EstadiasServlet", urlPatterns = {
        "/estadias/documentos", "/estadias/documento", "/estadias/reporte",
        "/estadias/historico", "/estadias/resultado"
})
public class EstadiasServlet extends HttpServlet {
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
        try {
            switch (request.getServletPath()) {
                case "/estadias/documentos" -> {
                    request.setAttribute("solicitudes", visitaService.listarParaEstadias(request.getParameter("q")));
                    forward(request, response, "/WEB-INF/views/estadias/documentos.jsp");
                }
                case "/estadias/historico" -> {
                    request.setAttribute("solicitudes", visitaService.listarHistoricoEstadias(request.getParameter("q")));
                    forward(request, response, "/WEB-INF/views/estadias/historico.jsp");
                }
                case "/estadias/documento" -> mostrarDocumentos(request, response);
                case "/estadias/reporte" -> mostrarReporte(request, response);
                case "/estadias/resultado" -> mostrarResultado(request, response);
                default -> response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (IllegalArgumentException exception) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, exception.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String path = request.getServletPath();
        if (!"/estadias/documento".equals(path) && !"/estadias/reporte".equals(path)) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }
        Long documentoId = id(request.getParameter("documentoId"));
        Documento documento = documentoService.buscarPorId(documentoId);
        if (documento == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        boolean esReporte = "REPORTE".equalsIgnoreCase(documento.getTipoDocumento());
        if (esReporte != "/estadias/reporte".equals(path)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        try {
            Usuario revisor = (Usuario) request.getSession(false).getAttribute("usuario");
            String decision = request.getParameter("decision");
            if (!"ACEPTAR".equals(decision) && !"RECHAZAR".equals(decision)) {
                throw new IllegalArgumentException("Decisión no válida.");
            }
            if (!documentoService.revisar(documentoId, decision,
                    request.getParameter("observaciones"), revisor.getIdUsuario())) {
                response.sendError(HttpServletResponse.SC_CONFLICT);
                return;
            }
            response.sendRedirect(request.getContextPath() + "/estadias/resultado?tipo="
                    + (esReporte ? "reporte" : "documento") + "&resultado="
                    + ("ACEPTAR".equals(decision) ? "aceptado" : "rechazado")
                    + "&visita=" + documento.getIdVisitaFk());
        } catch (IllegalArgumentException exception) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, exception.getMessage());
        }
    }

    private void mostrarDocumentos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ExpedienteVisita expediente = expediente(request);
        expediente.setDocumentos(documentoService.listarPorVisita(expediente.getIdVisita()));
        request.setAttribute("expediente", expediente);
        forward(request, response, "/WEB-INF/views/estadias/revisar-documentos.jsp");
    }

    private void mostrarReporte(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ExpedienteVisita expediente = expediente(request);
        Documento reporte = documentoService.buscarPorVisitaYTipo(expediente.getIdVisita(), "REPORTE");
        if (reporte == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "La visita aún no tiene reporte.");
            return;
        }
        request.setAttribute("expediente", expediente);
        request.setAttribute("reporte", reporte);
        forward(request, response, "/WEB-INF/views/estadias/revisar-reporte.jsp");
    }

    private void mostrarResultado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tipo = request.getParameter("tipo");
        String resultado = request.getParameter("resultado");
        if (!("documento".equals(tipo) || "reporte".equals(tipo))
                || !("aceptado".equals(resultado) || "rechazado".equals(resultado))) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        request.setAttribute("visitaId", request.getParameter("visita"));
        forward(request, response, "/WEB-INF/views/estadias/" + tipo + "-" + resultado + ".jsp");
    }

    private ExpedienteVisita expediente(HttpServletRequest request) {
        ExpedienteVisita expediente = visitaService.buscarParaEstadias(id(request.getParameter("id")));
        if (expediente == null) throw new IllegalArgumentException("Visita no encontrada.");
        return expediente;
    }

    private Long id(String value) {
        try { return Long.valueOf(value); }
        catch (RuntimeException exception) { throw new IllegalArgumentException("Identificador no válido."); }
    }

    private void forward(HttpServletRequest request, HttpServletResponse response, String jsp)
            throws ServletException, IOException {
        request.getRequestDispatcher(jsp).forward(request, response);
    }
}