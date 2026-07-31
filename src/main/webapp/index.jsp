<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="mx.edu.utez.awgva.Model.Usuario" %>
<%@ page import="mx.edu.utez.awgva.Model.SolicitudVisita" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inicio - AWGVA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background-color: #ffffff; min-height: 100vh; }
        .main-layout { margin-left: 240px; padding: 3rem 3.5rem; min-height: 100vh; background-color: #ffffff; }
        .top-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 2.5rem; }
        .page-title { color: #1e3a5f; font-size: 2rem; font-weight: 800; margin: 0; line-height: 1.1; }
        .page-subtitle { color: #f38218; font-size: 1.25rem; font-weight: 700; margin-top: 0.5rem; }

        .btn-new-request {
            background-color: #f38218; color: #ffffff; border: none; border-radius: 6px;
            padding: 0.6rem 1.6rem; font-weight: 600; font-size: 0.95rem; text-decoration: none;
            display: inline-flex; align-items: center; gap: 8px;
            box-shadow: 0 2px 4px rgba(243, 130, 24, 0.2); transition: background-color 0.2s ease;
        }
        .btn-new-request:hover { background-color: #d9700f; color: #ffffff; }

        .summary-card {
            border: 1px solid #e2e8f0; border-radius: 12px; padding: 2rem;
            background-color: #f8fafc; max-width: 500px; box-shadow: 0 2px 8px rgba(0,0,0,0.03);
        }
        .summary-card h3 { color: #1e3a5f; font-weight: 700; font-size: 1.4rem; margin-bottom: 0.5rem; }
        .summary-card p { color: #64748b; margin-bottom: 1.5rem; }
        .btn-view-all {
            color: #1e3a5f; font-weight: 600; text-decoration: none; display: inline-flex;
            align-items: center; gap: 6px; font-size: 0.95rem;
        }
        .btn-view-all:hover { text-decoration: underline; }
    </style>
</head>
<body>

<%
    List<SolicitudVisita> listaSolicitudes = (List<SolicitudVisita>) session.getAttribute("listaSolicitudes");
    int totalCreadas = (listaSolicitudes != null) ? listaSolicitudes.size() : 0;
%>

<jsp:include page="Layout/sidebar.jsp"/>

<main class="main-layout">

    <div class="top-header">
        <div>
            <h1 class="page-title">Inicio</h1>
            <div class="page-subtitle">
                Mis solicitudes
                <span style="font-size: 0.95rem; font-weight: 600; color: #64748b;">
                    (<%= totalCreadas %> <%= (totalCreadas == 1) ? "solicitud creada" : "solicitudes creadas" %>)
                </span>
            </div>
        </div>
        <div>
            <a href="nueva-solicitud.jsp" class="btn-new-request">
                <i class="bi bi-plus-circle"></i>
                Nueva solicitud
            </a>
        </div>
    </div>

    <!-- Caja resumen sin tarjetas -->
    <div class="summary-card">
        <h3>Estado de tu cuenta</h3>
        <% if (totalCreadas > 0) { %>
        <p>Tienes <strong><%= totalCreadas %></strong> <%= (totalCreadas == 1) ? "solicitud registrada" : "solicitudes registradas" %> actualmente.</p>
        <a href="mis-solicitudes.jsp" class="btn-view-all">
            Ver solicitudes en detalle <i class="bi bi-arrow-right"></i>
        </a>
        <% } else { %>
        <p>No tienes ninguna solicitud registrada en este momento.</p>
        <a href="nueva-solicitud.jsp" class="btn-new-request" style="padding: 0.4rem 1rem; font-size: 0.85rem;">
            Crear mi primera solicitud
        </a>
        <% } %>
    </div>

</main>

</body>
</html>