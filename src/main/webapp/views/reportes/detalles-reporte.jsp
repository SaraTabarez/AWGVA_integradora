<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");

    // Función Helper para obtener datos de sesión con un valor por defecto si está vacío
    class Helper {
        String val(HttpSession s, String key, String defaultValue) {
            Object v = s.getAttribute(key);
            return (v != null && !v.toString().trim().isEmpty()) ? v.toString() : defaultValue;
        }
    }
    Helper h = new Helper();

    // Cargar datos (Si la sesión está vacía, coloca datos de prueba automáticamente)
    String docente = h.val(session, "docenteResponsable", "Mtro. Juan Pérez López");
    String area = h.val(session, "areaSolicitante", "DATIC - Tecnologías de la Información");
    String empresa = h.val(session, "empresa", "Empresa de Tecnología UTEZ S.A. de C.V.");
    String direccion = h.val(session, "direccionEmpresa", "Av. Universidad No. 1, Emiliano Zapata, Mor.");
    String fecha = h.val(session, "fechaSolicitud", "2026-03-30");
    String objetivo = h.val(session, "objetivoVisita", "Visita técnica a las instalaciones del centro de cómputo.");
    String estatus = h.val(session, "estatusReporte", "EN REVISIÓN");

    String f1 = h.val(session, "foto1Base64", "");
    String f2 = h.val(session, "foto2Base64", "");
    String f3 = h.val(session, "foto3Base64", "");
    String fRep = h.val(session, "reporteFirmadoBase64", "");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Detalles del Reporte - UTEZ</title>
    <style>
        * { box-sizing: border-box; font-family: Arial, Helvetica, sans-serif; margin: 0; padding: 0; }
        html, body { height: 100%; background-color: #f4f6f9; color: #333; }
        body { display: flex; }

        .sidebar {
            width: 240px; height: 100vh; background-color: #1b365d; color: white;
            position: fixed; top: 0; left: 0; display: flex; flex-direction: column;
            justify-content: space-between; padding: 25px 0 20px 0; z-index: 100;
        }
        .user-profile-top { display: flex; align-items: center; gap: 12px; padding: 0 25px 20px 25px; border-bottom: 1px solid rgba(255, 255, 255, 0.15); margin-bottom: 15px; }
        .user-profile-top svg { width: 36px; height: 36px; fill: #fca311; background: rgba(255,255,255,0.1); border-radius: 50%; padding: 4px; }
        .user-name { font-size: 14px; font-weight: bold; color: white; }
        .user-role { font-size: 11px; color: #cbd5e1; }

        .menu-items { display: flex; flex-direction: column; gap: 10px; }
        .menu-item { display: flex; align-items: center; gap: 12px; color: white; text-decoration: none; padding: 12px 30px; font-size: 15px; font-weight: bold; }
        .menu-item.active { color: #ff8c00; background-color: rgba(255,255,255,0.05); }

        .main-container { margin-left: 240px; width: calc(100% - 240px); background-color: #ffffff; padding: 40px; min-height: 100vh; }

        .header-summary { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .header-title { font-size: 24px; font-weight: bold; color: #1e3a5f; }
        .status-badge { background-color: #fef3c7; color: #d97706; font-weight: bold; padding: 6px 16px; border-radius: 20px; font-size: 13px; }

        .summary-card { background-color: #f1f5f9; border-radius: 8px; padding: 20px; display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 30px; }
        .info-group label { font-size: 13px; font-weight: bold; color: #1e3a5f; display: block; margin-bottom: 3px; }
        .info-group span { font-size: 14px; color: #475569; }

        .section-title { font-size: 18px; font-weight: bold; color: #1e3a5f; margin-bottom: 15px; }

        .evidence-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; margin-bottom: 40px; }
        .photo-box { height: 120px; border: 1px dashed #cbd5e1; background-color: #e2e8f0; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-size: 12px; color: #64748b; overflow: hidden; }
        .photo-box img { width: 100%; height: 100%; object-fit: cover; }

        .actions-bar { display: flex; justify-content: space-between; align-items: center; }
        .btn-orange { background-color: #fca311; color: white; border: none; padding: 12px 24px; border-radius: 6px; font-weight: bold; cursor: pointer; text-decoration: none; }
        .btn-blue { background-color: #007bff; color: white; border: none; padding: 12px 24px; border-radius: 6px; font-weight: bold; cursor: pointer; text-decoration: none; }
    </style>
</head>
<body>

<div class="sidebar">
    <div>
        <div class="user-profile-top">
            <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
            <div>
                <div class="user-name">Docente Activo</div>
                <div class="user-role">Profesor</div>
            </div>
        </div>
        <nav class="menu-items">
            <a href="#" class="menu-item">Inicio</a>
            <a href="#" class="menu-item">Solicitud</a>
            <a href="#" class="menu-item active">Reporte</a>
            <a href="#" class="menu-item">Histórico</a>
        </nav>
    </div>
</div>

<div class="main-container">

    <div class="header-summary">
        <h1 class="header-title">Resumen del Reporte Enviado</h1>
        <span class="status-badge"><%= estatus %></span>
    </div>

    <div class="summary-card">
        <div class="info-group">
            <label>Docente Responsable:</label>
            <span><%= docente %></span>
        </div>
        <div class="info-group">
            <label>Área / División:</label>
            <span><%= area %></span>
        </div>
        <div class="info-group">
            <label>Empresa / Destino:</label>
            <span><%= empresa %></span>
        </div>
        <div class="info-group">
            <label>Dirección:</label>
            <span><%= direccion %></span>
        </div>
        <div class="info-group">
            <label>Fecha de Solicitud:</label>
            <span><%= fecha %></span>
        </div>
        <div class="info-group">
            <label>Objetivo:</label>
            <span><%= objetivo %></span>
        </div>
    </div>

    <h2 class="section-title">Evidencias Adjuntas</h2>

    <div class="evidence-grid">
        <div class="photo-box"><% if(!f1.isEmpty() && f1.startsWith("data:image")){ %><img src="<%= f1 %>"><% }else{ %>Sin foto 1<% } %></div>
        <div class="photo-box"><% if(!f2.isEmpty() && f2.startsWith("data:image")){ %><img src="<%= f2 %>"><% }else{ %>Sin foto 2<% } %></div>
        <div class="photo-box"><% if(!f3.isEmpty() && f3.startsWith("data:image")){ %><img src="<%= f3 %>"><% }else{ %>Sin foto 3<% } %></div>
        <div class="photo-box"><% if(!fRep.isEmpty() && fRep.startsWith("data:image")){ %><img src="<%= fRep %>"><% }else{ %>Sin reporte firmado<% } %></div>
    </div>

    <div class="actions-bar">
        <a href="<%= request.getContextPath() %>/views/reportes/corregir-reporte.jsp" class="btn-orange">Modificar Datos</a>
        <a href="<%= request.getContextPath() %>/views/reportes/revisar-reporte.jsp" class="btn-blue">Revisar Reporte (Vista Administrador / Revisor)</a>
    </div>

</div>

</body>
</html>