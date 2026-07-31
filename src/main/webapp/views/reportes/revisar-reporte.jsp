<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");

    // Procesamiento de acciones de Estadías (Aceptar / Rechazar)
    String accion = request.getParameter("accion");
    if ("aprobar".equalsIgnoreCase(accion)) {
        session.setAttribute("estatusReporte", "ACEPTADO");
        response.sendRedirect(request.getContextPath() + "/views/reportes/revisar-reporte.jsp?estado=aceptado");
        return;
    } else if ("rechazar".equalsIgnoreCase(accion)) {
        session.setAttribute("estatusReporte", "RECHAZADO");
        response.sendRedirect(request.getContextPath() + "/views/reportes/revisar-reporte.jsp?estado=rechazado");
        return;
    }

    class Helper {
        String val(HttpSession s, String key) {
            Object v = s.getAttribute(key);
            return (v != null && !v.toString().trim().isEmpty()) ? v.toString() : "N/A";
        }
    }
    Helper h = new Helper();
    String estadoQuery = request.getParameter("estado");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Revisar Reporte - Estadías UTEZ</title>
    <style>
        * { box-sizing: border-box; font-family: Arial, Helvetica, sans-serif; margin: 0; padding: 0; }
        html, body { height: 100%; margin: 0; padding: 0; background-color: #f4f6f9; color: #333; }
        body { display: flex; }

        /* Alineación fija de la barra lateral */
        .sidebar {
            width: 240px;
            height: 100vh;
            background-color: #1b365d;
            color: white;
            position: fixed;
            top: 0;
            left: 0;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 25px 0 20px 0;
            z-index: 100;
        }
        .user-profile-top { display: flex; align-items: center; gap: 12px; padding: 0 25px 20px 25px; border-bottom: 1px solid rgba(255, 255, 255, 0.15); margin-bottom: 15px; }
        .user-profile-top svg { width: 36px; height: 36px; fill: #fca311; background: rgba(255,255,255,0.1); border-radius: 50%; padding: 4px; }
        .user-name { font-size: 14px; font-weight: bold; color: white; }
        .user-role { font-size: 11px; color: #cbd5e1; }

        .menu-items { display: flex; flex-direction: column; gap: 10px; }
        .menu-item { display: flex; align-items: center; gap: 12px; color: white; text-decoration: none; padding: 12px 30px; font-size: 15px; font-weight: bold; }
        .menu-item svg { width: 20px; height: 20px; fill: currentColor; }
        .menu-item.active { color: #ff8c00; background-color: rgba(255,255,255,0.05); }

        /* Contenedor principal alineado */
        .main-container {
            margin-left: 240px;
            width: calc(100% - 240px);
            background-color: #ffffff;
            padding: 20px 40px 40px 40px;
            min-height: 100vh;
        }

        .stepper-box { border: 1px solid #777; border-radius: 4px; padding: 10px; margin-bottom: 25px; }
        .stepper { display: flex; justify-content: space-between; align-items: flex-start; position: relative; }
        .stepper-line { position: absolute; top: 20px; left: 30px; right: 30px; height: 2px; background-color: #ccc; z-index: 1; }
        .step { position: relative; z-index: 2; text-align: center; width: 80px; }
        .step-icon { width: 36px; height: 36px; border-radius: 50%; background-color: #e59339; color: white; margin: 0 auto 5px auto; display: flex; align-items: center; justify-content: center; font-size: 14px; font-weight: bold; }
        .step-text { font-size: 10px; color: #333; }

        .header-section { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; }
        .header-title { font-size: 22px; font-weight: bold; color: #1e3a5f; text-transform: uppercase; }
        .logo-utez { text-align: right; font-weight: bold; font-size: 20px; color: #002b49; }

        .section-title { font-size: 18px; color: #2c4a6f; margin-bottom: 12px; font-weight: bold; margin-top: 15px; }
        .form-grid { display: grid; gap: 12px 15px; margin-bottom: 10px; }
        .grid-2 { grid-template-columns: 2fr 1fr; }
        .grid-3 { grid-template-columns: 1fr 1fr 1fr; }
        .grid-4 { grid-template-columns: 2fr 1fr 1fr 1fr; }

        .form-group { display: flex; flex-direction: column; }
        .form-group label { font-size: 12px; font-weight: bold; color: #1e3a5f; margin-bottom: 4px; }
        .form-group input { background-color: #e3ebf3; border: 1px solid #c0d1e3; border-radius: 4px; padding: 8px 12px; font-size: 13px; color: #333; outline: none; }

        .evidence-box { border: 1px solid #777; padding: 15px; margin-top: 20px; margin-bottom: 30px; display: flex; justify-content: space-between; gap: 20px; }
        .photos-container { display: flex; gap: 12px; margin-top: 10px; }
        .photo-preview-box { width: 120px; height: 80px; border: 1px dashed #0099ff; border-radius: 4px; background: #f0f7ff; display: flex; align-items: center; justify-content: center; overflow: hidden; position: relative; font-size: 11px; color: #666; }
        .photo-preview-box img { width: 100%; height: 100%; object-fit: cover; }

        .bottom-bar { display: flex; justify-content: space-between; align-items: center; margin-top: 20px; }
        .btn-atras { background-color: #fca311; color: white; border: none; padding: 10px 30px; border-radius: 6px; font-weight: bold; cursor: pointer; }
        .btn-rechazar { background-color: #a61c1c; color: white; border: none; padding: 10px 20px; border-radius: 6px; font-weight: bold; cursor: pointer; margin-right: 10px; }
        .btn-aprobar { background-color: #48bb78; color: white; border: none; padding: 10px 20px; border-radius: 6px; font-weight: bold; cursor: pointer; }

        /* Pop-ups Modales */
        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); display: none; justify-content: center; align-items: center; z-index: 1000; }
        .modal-card { background: white; border-radius: 12px; padding: 30px; width: 420px; text-align: center; box-shadow: 0 4px 15px rgba(0,0,0,0.2); position: relative; }
        .icon-check { width: 60px; height: 60px; border: 3px solid #48bb78; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px auto; color: #48bb78; font-size: 32px; font-weight: bold; }
        .icon-cross { width: 60px; height: 60px; border: 2px dashed #a61c1c; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px auto; color: #a61c1c; font-size: 32px; font-weight: bold; }
        .modal-card h3 { font-size: 18px; margin-bottom: 12px; color: #222; }
        .modal-card p { font-size: 13px; color: #555; margin-bottom: 20px; line-height: 1.4; }
        .btn-modal-green { background-color: #48bb78; color: white; border: none; padding: 10px 30px; border-radius: 6px; font-weight: bold; cursor: pointer; width: 100%; }
        .btn-modal-red { background-color: #a61c1c; color: white; border: none; padding: 10px 25px; border-radius: 6px; font-weight: bold; cursor: pointer; }
        .btn-modal-cancel { background-color: transparent; border: 1px solid #ccc; color: #555; padding: 10px 25px; border-radius: 6px; font-weight: bold; cursor: pointer; margin-right: 10px; }
    </style>
</head>
<body>

<div class="sidebar">
    <div>
        <div class="user-profile-top">
            <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
            <div class="user-info">
                <span class="user-name">Administrador</span>
                <span class="user-role">Estadías UTEZ</span>
            </div>
        </div>
        <nav class="menu-items">
            <a href="#" class="menu-item"><svg viewBox="0 0 24 24"><path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/></svg> Inicio</a>
            <a href="#" class="menu-item"><svg viewBox="0 0 24 24"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg> Solicitud</a>
            <a href="#" class="menu-item active"><svg viewBox="0 0 24 24"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg> Reporte</a>
            <a href="#" class="menu-item"><svg viewBox="0 0 24 24"><path d="M13 3c-4.97 0-9 4.03-9 9H1l3.89 3.89.07.14L9 12H6c0-3.87 3.13-7 7-7s7 3.13 7 7-3.13 7-7 7c-1.93 0-3.68-.79-4.94-2.06l-1.42 1.42C8.27 19.99 10.51 21 13 21c4.97 0 9-4.03 9-9s-4.03-9-9-9zm-1 5v5l4.28 2.54.72-1.21-3.5-2.08V8H12z"/></svg> Histórico</a>
        </nav>
    </div>
</div>

<div class="main-container">

    <div class="stepper-box">
        <div class="stepper">
            <div class="stepper-line"></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Solicitud creada</div></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Solicitud enviada</div></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Solicitud aceptada</div></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Carta responsiva enviada</div></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Carta responsiva aceptada</div></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Visita en curso</div></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Reporte enviado</div></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Reporte aceptado</div></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Visita concretada</div></div>
        </div>
    </div>

    <div class="header-section">
        <div>
            <h1 class="header-title">REPORTE DE VISITA ACADÉMICA</h1>
            <div style="margin-top: 15px;">
                <div class="form-group" style="width: 240px;">
                    <label>Fecha de solicitud:</label>
                    <input type="text" readonly value="<%= h.val(session, "fechaSolicitud") %>">
                </div>
            </div>
        </div>
        <div>
            <div class="logo-utez">UTEZ</div>
            <div style="font-size:12px; font-weight:bold; margin-top:10px;">FO-UTEZ-EST-08<br>rev.08</div>
        </div>
    </div>

    <!-- Datos del Reporte Completo -->
    <div class="section-title">Datos de los participantes y Responsables</div>
    <div class="form-grid grid-3">
        <div class="form-group"><label>Área del solicitante:</label><input type="text" readonly value="<%= h.val(session, "areaSolicitante") %>"></div>
        <div class="form-group"><label>Docente responsable:</label><input type="text" readonly value="<%= h.val(session, "docenteResponsable") %>"></div>
        <div class="form-group"><label>Teléfono de contacto:</label><input type="text" readonly value="<%= h.val(session, "telefonoDocente") %>"></div>
    </div>

    <div class="form-grid grid-2">
        <div class="form-group"><label>Docente acompañante:</label><input type="text" readonly value="<%= h.val(session, "docenteAcompanante") %>"></div>
        <div class="form-group"><label>División o área del participante:</label><input type="text" readonly value="<%= h.val(session, "divisionParticipante") %>"></div>
    </div>

    <div class="form-grid grid-4">
        <div class="form-group"><label>Programa educativo:</label><input type="text" readonly value="<%= h.val(session, "programaEducativo1") %>"></div>
        <div class="form-group"><label>Cuatrimestre:</label><input type="text" readonly value="<%= h.val(session, "cuatrimestre1") %>"></div>
        <div class="form-group"><label>Grupo:</label><input type="text" readonly value="<%= h.val(session, "grupo1") %>"></div>
        <div class="form-group"><label>Nu. de Estudiantes:</label><input type="text" readonly value="<%= h.val(session, "numEstudiantes1") %>"></div>
    </div>

    <div class="form-grid grid-4">
        <div class="form-group"><label>Programa educativo:</label><input type="text" readonly value="<%= h.val(session, "programaEducativo2") %>"></div>
        <div class="form-group"><label>Cuatrimestre:</label><input type="text" readonly value="<%= h.val(session, "cuatrimestre2") %>"></div>
        <div class="form-group"><label>Grupo:</label><input type="text" readonly value="<%= h.val(session, "grupo2") %>"></div>
        <div class="form-group"><label>Nu. de Estudiantes:</label><input type="text" readonly value="<%= h.val(session, "numEstudiantes2") %>"></div>
    </div>

    <div class="section-title">Datos del lugar a visitar</div>
    <div class="form-grid grid-3">
        <div class="form-group"><label>Nombre de la empresa o actividad:</label><input type="text" readonly value="<%= h.val(session, "empresa") %>"></div>
        <div class="form-group"><label>Lugar o dirección:</label><input type="text" readonly value="<%= h.val(session, "direccionEmpresa") %>"></div>
        <div class="form-group"><label>Teléfono de contacto:</label><input type="text" readonly value="<%= h.val(session, "telefonoEmpresa") %>"></div>
    </div>

    <div class="form-grid grid-4">
        <div class="form-group"><label>Correo electrónico:</label><input type="text" readonly value="<%= h.val(session, "correoEmpresa") %>"></div>
        <div class="form-group"><label>Objetivo de la visita:</label><input type="text" readonly value="<%= h.val(session, "objetivoVisita") %>"></div>
        <div class="form-group"><label>Fecha de inicio:</label><input type="text" readonly value="<%= h.val(session, "fechaInicio") %>"></div>
        <div class="form-group"><label>Fecha de término:</label><input type="text" readonly value="<%= h.val(session, "fechaTermino") %>"></div>
    </div>

    <!-- Evidencias Cargadas -->
    <div class="evidence-box">
        <div>
            <div style="font-weight:bold; color:#e59339; margin-bottom:10px;">Subida de Documentos y Evidencias</div>
            <div class="photos-container">
                <%
                    String f1 = h.val(session, "foto1Base64");
                    String f2 = h.val(session, "foto2Base64");
                    String f3 = h.val(session, "foto3Base64");
                    String fRep = h.val(session, "reporteFirmadoBase64");
                %>
                <div class="photo-preview-box"><% if(!f1.equals("N/A") && f1.startsWith("data:image")){ %><img src="<%= f1 %>"><% }else{ %>Sin Foto 1<% } %></div>
                <div class="photo-preview-box"><% if(!f2.equals("N/A") && f2.startsWith("data:image")){ %><img src="<%= f2 %>"><% }else{ %>Sin Foto 2<% } %></div>
                <div class="photo-preview-box"><% if(!f3.equals("N/A") && f3.startsWith("data:image")){ %><img src="<%= f3 %>"><% }else{ %>Sin Foto 3<% } %></div>
            </div>
        </div>
        <div style="border-left:1px solid #ddd; padding-left:20px;">
            <div style="font-weight:bold; color:#e59339; margin-bottom:10px;">Descarga de Reporte firmado:</div>
            <% if(!fRep.equals("N/A") && !fRep.isEmpty()) { %>
            <a href="<%= fRep %>" download="Reporte_Firmado.png" class="btn-atras" style="text-decoration:none; display:inline-block; font-size:12px;">⬇ Descargar Reporte</a>
            <% } else { %>
            <span style="font-size:12px; color:#888;">No disponible</span>
            <% } %>
        </div>
    </div>

    <!-- Botones de Acción -->
    <div class="bottom-bar">
        <button class="btn-atras" onclick="window.history.back()">Atrás</button>
        <div>
            <button class="btn-rechazar" onclick="abrirModalRechazar()">Rechazar Reporte</button>
            <button class="btn-aprobar" onclick="abrirModalAceptar()">Aprobar Reporte</button>
        </div>
    </div>

</div>

<!-- Modal 1: Confirmar Rechazo -->
<div class="modal-overlay" id="modalRechazar">
    <div class="modal-card">
        <div class="icon-cross">✕</div>
        <h3>Reporte Rechazado</h3>
        <p>Se notificará al docente que el reporte fue rechazado. Esta acción no se puede deshacer.</p>
        <div style="display:flex; justify-content:center;">
            <button class="btn-modal-cancel" onclick="cerrarModalRechazar()">Cancelar</button>
            <form action="revisar-reporte.jsp" method="post" style="display:inline;">
                <input type="hidden" name="accion" value="rechazar">
                <button type="submit" class="btn-modal-red">Rechazar</button>
            </form>
        </div>
    </div>
</div>

<!-- Modal 2: Confirmar Aceptación -->
<div class="modal-overlay" id="modalAceptar">
    <div class="modal-card">
        <div class="icon-check">✓</div>
        <h3>¡Reporte Aceptado!</h3>
        <p>El reporte ha sido aprobado con éxito y ya se encuentra guardado en el historial.</p>
        <form action="revisar-reporte.jsp" method="post">
            <input type="hidden" name="accion" value="aprobar">
            <button type="submit" class="btn-modal-green">Entendido</button>
        </form>
    </div>
</div>

<script>
    function abrirModalRechazar() {
        document.getElementById('modalRechazar').style.display = 'flex';
    }
    function cerrarModalRechazar() {
        document.getElementById('modalRechazar').style.display = 'none';
    }
    function abrirModalAceptar() {
        document.getElementById('modalAceptar').style.display = 'flex';
    }

    <% if ("aceptado".equals(estadoQuery)) { %>
    abrirModalAceptar();
    <% } else if ("rechazado".equals(estadoQuery)) { %>
    abrirModalRechazar();
    <% } %>
</script>
</body>
</html>