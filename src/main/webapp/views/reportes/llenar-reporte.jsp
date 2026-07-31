<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 1. CONTROL DE FLUJO Y SESIÓN
    request.setCharacterEncoding("UTF-8");

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        session.setAttribute("fechaSolicitud", request.getParameter("fechaSolicitud"));
        session.setAttribute("areaSolicitante", request.getParameter("areaSolicitante"));
        session.setAttribute("docenteResponsable", request.getParameter("docenteResponsable"));
        session.setAttribute("telefonoDocente", request.getParameter("telefonoDocente"));
        session.setAttribute("docenteAcompanante", request.getParameter("docenteAcompanante"));
        session.setAttribute("divisionParticipante", request.getParameter("divisionParticipante"));

        // Fila 1
        session.setAttribute("programaEducativo1", request.getParameter("programaEducativo1"));
        session.setAttribute("cuatrimestre1", request.getParameter("cuatrimestre1"));
        session.setAttribute("grupo1", request.getParameter("grupo1"));
        session.setAttribute("numEstudiantes1", request.getParameter("numEstudiantes1"));

        // Fila 2
        session.setAttribute("programaEducativo2", request.getParameter("programaEducativo2"));
        session.setAttribute("cuatrimestre2", request.getParameter("cuatrimestre2"));
        session.setAttribute("grupo2", request.getParameter("grupo2"));
        session.setAttribute("numEstudiantes2", request.getParameter("numEstudiantes2"));

        // Empresa
        session.setAttribute("empresa", request.getParameter("empresa"));
        session.setAttribute("direccionEmpresa", request.getParameter("direccionEmpresa"));
        session.setAttribute("telefonoEmpresa", request.getParameter("telefonoEmpresa"));
        session.setAttribute("correoEmpresa", request.getParameter("correoEmpresa"));
        session.setAttribute("objetivoVisita", request.getParameter("objetivoVisita"));
        session.setAttribute("fechaInicio", request.getParameter("fechaInicio"));
        session.setAttribute("fechaTermino", request.getParameter("fechaTermino"));

        // Evidencias
        if (request.getParameter("foto1Base64") != null && !request.getParameter("foto1Base64").isEmpty()) {
            session.setAttribute("foto1Base64", request.getParameter("foto1Base64"));
        }
        if (request.getParameter("foto2Base64") != null && !request.getParameter("foto2Base64").isEmpty()) {
            session.setAttribute("foto2Base64", request.getParameter("foto2Base64"));
        }
        if (request.getParameter("foto3Base64") != null && !request.getParameter("foto3Base64").isEmpty()) {
            session.setAttribute("foto3Base64", request.getParameter("foto3Base64"));
        }
        if (request.getParameter("reporteFirmadoBase64") != null && !request.getParameter("reporteFirmadoBase64").isEmpty()) {
            session.setAttribute("reporteFirmadoBase64", request.getParameter("reporteFirmadoBase64"));
        }

        session.setAttribute("estatusReporte", "PENDIENTE_REVISION");
        response.sendRedirect(request.getContextPath() + "/views/reportes/detalles-reporte.jsp");
        return;
    }

    String estatus = (String) session.getAttribute("estatusReporte");
    int pasoActual = 7;

    if ("PENDIENTE_REVISION".equals(estatus)) {
        pasoActual = 8;
    } else if ("ACEPTADO".equals(estatus) || "CONCRETADO".equals(estatus)) {
        pasoActual = 9;
    }

    class Helper {
        String val(HttpSession s, String key) {
            Object v = s.getAttribute(key);
            return (v != null) ? v.toString() : "";
        }
    }
    Helper h = new Helper();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Llenar Reporte Docente - UTEZ</title>
    <style>
        * { box-sizing: border-box; font-family: Arial, Helvetica, sans-serif; margin: 0; padding: 0; }
        body { display: flex; background-color: #f4f6f9; color: #333; }

        /* Sidebar lateral */
        .sidebar {
            width: 240px; height: 100vh; background-color: #1b365d; color: white;
            position: fixed; display: flex; flex-direction: column; justify-content: space-between; padding: 25px 0 20px 0;
            z-index: 10;
        }

        /* Perfil de Usuario Superior */
        .user-profile-top {
            display: flex; align-items: center; gap: 12px; padding: 0 25px 20px 25px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.15); margin-bottom: 15px;
        }
        .user-profile-top svg { width: 36px; height: 36px; fill: #fca311; background: rgba(255,255,255,0.1); border-radius: 50%; padding: 4px; flex-shrink: 0; }
        .user-info { display: flex; flex-direction: column; }
        .user-name { font-size: 14px; font-weight: bold; color: white; }
        .user-role { font-size: 11px; color: #cbd5e1; }

        .menu-items { display: flex; flex-direction: column; gap: 10px; flex-grow: 1; }
        .menu-item {
            display: flex; align-items: center; gap: 12px; color: white; text-decoration: none;
            padding: 12px 30px; font-size: 15px; font-weight: bold; transition: 0.2s;
        }
        .menu-item svg { width: 20px; height: 20px; fill: currentColor; }
        .menu-item:hover { background-color: rgba(255, 255, 255, 0.08); }
        .menu-item.active { color: #ff8c00; }

        /* Logout inferior */
        .logout-box { padding: 15px 25px 0 25px; border-top: 1px solid rgba(255, 255, 255, 0.15); }
        .logout-link { display: flex; align-items: center; gap: 10px; color: #ff6b6b; text-decoration: none; font-size: 14px; font-weight: bold; }
        .logout-link svg { width: 18px; height: 18px; fill: #ff6b6b; }

        /* Contenido Principal */
        .main-container {
            margin-left: 240px; width: calc(100% - 240px); background-color: #ffffff;
            padding: 20px 40px 40px 40px; min-height: 100vh;
        }

        .location-badge {
            background-color: #e3ebf3; color: #1b365d; font-size: 12px; font-weight: bold;
            padding: 6px 12px; border-radius: 4px; display: inline-block; margin-bottom: 15px;
            border-left: 4px solid #fca311;
        }

        /* Stepper */
        .stepper-box { border: 1px solid #777; border-radius: 4px; padding: 10px; margin-bottom: 25px; background: #fff; }
        .stepper { display: flex; justify-content: space-between; align-items: flex-start; position: relative; }
        .stepper-line { position: absolute; top: 20px; left: 30px; right: 30px; height: 2px; background-color: #ccc; z-index: 1; }

        .step { position: relative; z-index: 2; text-align: center; width: 80px; }
        .step-icon {
            width: 36px; height: 36px; border-radius: 50%; background-color: #e59339; color: white;
            margin: 0 auto 5px auto; display: flex; align-items: center; justify-content: center;
            font-size: 14px; font-weight: bold; transition: all 0.3s ease;
        }
        .step-icon.disabled { background-color: #ccc; color: transparent; }
        .step-text { font-size: 10px; color: #333; line-height: 1.1; }

        /* Encabezado */
        .header-section { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; }
        .header-title { font-size: 22px; font-weight: bold; color: #1e3a5f; text-transform: uppercase; }
        .logo-utez { text-align: right; font-weight: bold; font-size: 20px; color: #002b49; font-style: italic; }
        .logo-sub { font-size: 8px; display: block; color: #555; font-style: normal; }
        .format-code { text-align: right; font-size: 13px; font-weight: bold; color: #222; }

        /* Formularios */
        .section-box { border: 2px solid #0099ff; border-radius: 4px; padding: 15px; margin-bottom: 25px; }
        .section-title { font-size: 18px; color: #2c4a6f; margin-bottom: 12px; font-weight: bold; }

        .form-grid { display: grid; gap: 12px 15px; margin-bottom: 10px; }
        .grid-2 { grid-template-columns: 2fr 1fr; }
        .grid-3 { grid-template-columns: 1fr 1fr 1fr; }
        .grid-4 { grid-template-columns: 2fr 1fr 1fr 1fr; }

        .form-group { display: flex; flex-direction: column; }
        .form-group label { font-size: 12px; font-weight: bold; color: #1e3a5f; margin-bottom: 4px; }
        .form-group input {
            background-color: #e3ebf3; border: 1px solid #c0d1e3; border-radius: 4px; padding: 8px 12px; font-size: 13px; color: #333; outline: none;
        }
        .form-group input:focus { border-color: #0099ff; background-color: #fff; }

        .evidence-box { border: 1px solid #777; padding: 15px; margin-top: 20px; margin-bottom: 30px; display: flex; justify-content: space-between; gap: 20px; }
        .evidence-left { flex: 1.5; }
        .evidence-right { flex: 1; border-left: 1px solid #ddd; padding-left: 20px; }
        .evidence-title { font-weight: bold; color: #e59339; font-size: 15px; margin-bottom: 10px; }

        .photos-container { display: flex; gap: 12px; margin-top: 10px; }
        .photo-uploader {
            width: 120px; height: 80px; border: 1px dashed #0099ff; border-radius: 4px; background: #f0f7ff;
            display: flex; flex-direction: column; align-items: center; justify-content: center; cursor: pointer; text-align: center; font-size: 10px; position: relative; overflow: hidden;
        }
        .photo-uploader img { width: 100%; height: 100%; object-fit: cover; position: absolute; top:0; left:0; }

        /* Botones */
        .bottom-bar { display: flex; justify-content: space-between; align-items: center; margin-top: 20px; }
        .btn-atras { background-color: #fca311; color: white; border: none; padding: 10px 30px; border-radius: 6px; font-weight: bold; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-responsiva { background-color: #2b6cb0; color: white; border: none; padding: 10px 18px; border-radius: 6px; font-weight: bold; cursor: pointer; margin-right: 8px; }
        .btn-guardar { background-color: #fca311; color: white; border: none; padding: 10px 25px; border-radius: 6px; font-weight: bold; cursor: pointer; transition: background-color 0.2s; }
        .btn-guardar:hover { background-color: #e59339; }

        /* Modal Carta Responsiva */
        .modal-overlay { position: fixed; top:0; left:0; width:100%; height:100%; background: rgba(0,0,0,0.6); display:none; justify-content:center; align-items:center; z-index:1000; }
        .modal-body { background:#fff; width:800px; max-height:90vh; overflow-y:auto; padding:30px; border-radius:8px; position:relative; font-size:13px; line-height:1.5; color:#000; }
        .btn-close-modal { position:absolute; top:15px; right:15px; border:none; background:#e53e3e; color:#fff; width:28px; height:28px; border-radius:50%; font-weight:bold; cursor:pointer; }
        .carta-table { width:100%; border-collapse: collapse; margin-top:15px; }
        .carta-table th, .carta-table td { border: 1px solid #000; padding:6px; text-align:center; font-size:12px; }

        @media print {
            .sidebar, .stepper-box, .bottom-bar, .no-print, .location-badge, .modal-overlay { display: none !important; }
            .main-container { margin-left: 0 !important; width: 100% !important; padding: 0 !important; }
            .section-box { border: 1px solid #000 !important; }
            input { background-color: #fff !important; border: 1px solid #000 !important; }
        }
    </style>
</head>
<body>

<!-- Menú Lateral -->
<div class="sidebar">
    <div>
        <!-- Perfil Usuario arriba -->
        <div class="user-profile-top">
            <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
            <div class="user-info">
                <span class="user-name">Docente Activo</span>
                <span class="user-role">Profesor</span>
            </div>
        </div>

        <!-- Elementos del Menú -->
        <nav class="menu-items">
            <a href="${pageContext.request.contextPath}/views/inicio.jsp" class="menu-item">
                <svg viewBox="0 0 24 24"><path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/></svg>
                Inicio
            </a>
            <a href="${pageContext.request.contextPath}/views/solicitudes/solicitud.jsp" class="menu-item">
                <svg viewBox="0 0 24 24"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg>
                Solicitud
            </a>
            <a href="${pageContext.request.contextPath}/views/reportes/llenar-reporte.jsp" class="menu-item active">
                <svg viewBox="0 0 24 24"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg>
                Reporte
            </a>
            <a href="${pageContext.request.contextPath}/views/historico/historico.jsp" class="menu-item">
                <svg viewBox="0 0 24 24"><path d="M13 3c-4.97 0-9 4.03-9 9H1l3.89 3.89.07.14L9 12H6c0-3.87 3.13-7 7-7s7 3.13 7 7-3.13 7-7 7c-1.93 0-3.68-.79-4.94-2.06l-1.42 1.42C8.27 19.99 10.51 21 13 21c4.97 0 9-4.03 9-9s-4.03-9-9-9zm-1 5v5l4.28 2.54.72-1.21-3.5-2.08V8H12z"/></svg>
                Histórico
            </a>
        </nav>
    </div>

    <!-- Cerrar sesión abajo -->
    <div class="logout-box">
        <a href="${pageContext.request.contextPath}/logout" class="logout-link">
            <svg viewBox="0 0 24 24"><path d="M10.09 15.59L11.5 17l5-5-5-5-1.41 1.41L12.67 11H3v2h9.67l-2.58 2.59zM19 3H5c-1.11 0-2 .9-2 2v4h2V5h14v14H5v-4H3v4c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z"/></svg>
            Cerrar sesión
        </a>
    </div>
</div>

<div class="main-container">

    <div class="location-badge">📍 Estás en: Módulo de Reportes &gt; Llenar Reporte de Visita</div>

    <!-- Stepper Dinámico -->
    <div class="stepper-box">
        <div class="stepper">
            <div class="stepper-line"></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Solicitud creada</div></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Solicitud enviada</div></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Solicitud aceptada</div></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Carta responsiva enviada</div></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Carta responsiva aceptada</div></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Visita en curso</div></div>
            <div class="step"><div class="step-icon <%= pasoActual >= 7 ? "" : "disabled" %>">✓</div><div class="step-text">Llenar Reporte</div></div>
            <div class="step"><div class="step-icon <%= pasoActual >= 8 ? "" : "disabled" %>"><%= pasoActual >= 8 ? "✓" : "" %></div><div class="step-text">Reporte aceptado</div></div>
            <div class="step"><div class="step-icon <%= pasoActual >= 9 ? "" : "disabled" %>"><%= pasoActual >= 9 ? "✓" : "" %></div><div class="step-text">Visita concretada</div></div>
        </div>
    </div>

    <!-- Encabezado -->
    <div class="header-section">
        <div>
            <h1 class="header-title">REPORTE DE VISITA ACADÉMICA</h1>
            <div style="margin-top: 15px;">
                <div class="form-group" style="width: 240px;">
                    <label>Fecha de solicitud:</label>
                    <input type="text" form="formReporte" id="fechaSolicitud" name="fechaSolicitud" value="<%= h.val(session, "fechaSolicitud") %>" placeholder="DD/MM/AAAA" onchange="actualizarCamposResponsiva()">
                </div>
            </div>
        </div>
        <div>
            <div class="logo-utez">
                UTEZ
                <span class="logo-sub">UNIVERSIDAD TECNOLÓGICA DEL ESTADO DE MORELOS</span>
            </div>
            <div class="format-code" style="margin-top: 15px;">
                FO-UTEZ-EST-08<br>rev.08
            </div>
        </div>
    </div>

    <form id="formReporte" action="${pageContext.request.contextPath}/views/reportes/llenar-reporte.jsp" method="post">

        <!-- Sección Datos del Responsable -->
        <div class="section-box">
            <div class="section-title">Datos de los participantes y Responsables</div>

            <div class="form-grid grid-3">
                <div class="form-group"><label>Área del solicitante:</label><input type="text" name="areaSolicitante" value="<%= h.val(session, "areaSolicitante") %>"></div>
                <div class="form-group"><label>Docente responsable:</label><input type="text" name="docenteResponsable" value="<%= h.val(session, "docenteResponsable") %>"></div>
                <div class="form-group"><label>Teléfono de contacto:</label><input type="text" name="telefonoDocente" value="<%= h.val(session, "telefonoDocente") %>"></div>
            </div>

            <div class="form-grid grid-2">
                <div class="form-group"><label>Docente acompañante:</label><input type="text" name="docenteAcompanante" value="<%= h.val(session, "docenteAcompanante") %>"></div>
                <div class="form-group"><label>División o área del participante:</label><input type="text" name="divisionParticipante" value="<%= h.val(session, "divisionParticipante") %>"></div>
            </div>

            <div class="form-grid grid-4">
                <div class="form-group"><label>Programa educativo:</label><input type="text" id="progEdu1" name="programaEducativo1" value="<%= h.val(session, "programaEducativo1") %>" onchange="actualizarCamposResponsiva()"></div>
                <div class="form-group"><label>Cuatrimestre:</label><input type="text" name="cuatrimestre1" value="<%= h.val(session, "cuatrimestre1") %>"></div>
                <div class="form-group"><label>Grupo:</label><input type="text" name="grupo1" value="<%= h.val(session, "grupo1") %>"></div>
                <div class="form-group"><label>Nu. de Estudiantes:</label><input type="text" name="numEstudiantes1" value="<%= h.val(session, "numEstudiantes1") %>"></div>
            </div>

            <div class="form-grid grid-4">
                <div class="form-group"><label>Programa educativo:</label><input type="text" name="programaEducativo2" value="<%= h.val(session, "programaEducativo2") %>"></div>
                <div class="form-group"><label>Cuatrimestre:</label><input type="text" name="cuatrimestre2" value="<%= h.val(session, "cuatrimestre2") %>"></div>
                <div class="form-group"><label>Grupo:</label><input type="text" name="grupo2" value="<%= h.val(session, "grupo2") %>"></div>
                <div class="form-group"><label>Nu. de Estudiantes:</label><input type="text" name="numEstudiantes2" value="<%= h.val(session, "numEstudiantes2") %>"></div>
            </div>
        </div>

        <!-- Sección Datos Empresa -->
        <div class="section-title">Datos del lugar a visitar</div>

        <div class="form-grid grid-3">
            <div class="form-group"><label>Nombre de la empresa o actividad:</label><input type="text" id="empresaNom" name="empresa" value="<%= h.val(session, "empresa") %>" onchange="actualizarCamposResponsiva()"></div>
            <div class="form-group"><label>Lugar o dirección:</label><input type="text" name="direccionEmpresa" value="<%= h.val(session, "direccionEmpresa") %>"></div>
            <div class="form-group"><label>Teléfono de contacto:</label><input type="text" name="telefonoEmpresa" value="<%= h.val(session, "telefonoEmpresa") %>"></div>
        </div>

        <div class="form-grid grid-4">
            <div class="form-group"><label>Correo electrónico:</label><input type="text" name="correoEmpresa" value="<%= h.val(session, "correoEmpresa") %>"></div>
            <div class="form-group"><label>Objetivo de la visita:</label><input type="text" name="objetivoVisita" value="<%= h.val(session, "objetivoVisita") %>"></div>
            <div class="form-group"><label>Fecha de inicio:</label><input type="text" id="fechaIni" name="fechaInicio" value="<%= h.val(session, "fechaInicio") %>" onchange="actualizarCamposResponsiva()"></div>
            <div class="form-group"><label>Fecha de término:</label><input type="text" id="fechaFin" name="fechaTermino" value="<%= h.val(session, "fechaTermino") %>" onchange="actualizarCamposResponsiva()"></div>
        </div>

        <!-- Evidencias Fotográficas -->
        <div class="evidence-box">
            <div class="evidence-left">
                <div class="evidence-title">1. Subida de Fotografías (Evidencias)</div>
                <div class="photos-container">
                    <%
                        String f1 = h.val(session, "foto1Base64");
                        String f2 = h.val(session, "foto2Base64");
                        String f3 = h.val(session, "foto3Base64");
                        String fRep = h.val(session, "reporteFirmadoBase64");
                    %>
                    <div class="photo-uploader" onclick="document.getElementById('f1').click()">
                        <span id="txt1" style="<%= !f1.isEmpty() ? "display:none;" : "" %>">📷 Cargar Foto 1</span>
                        <img id="img1" src="<%= f1 %>" style="<%= f1.isEmpty() ? "display:none;" : "" %>">
                        <input type="file" id="f1" accept="image/*" style="display:none" onchange="cargarPreview(this, 'img1', 'txt1', 'foto1Base64')">
                    </div>
                    <div class="photo-uploader" onclick="document.getElementById('f2').click()">
                        <span id="txt2" style="<%= !f2.isEmpty() ? "display:none;" : "" %>">📷 Cargar Foto 2</span>
                        <img id="img2" src="<%= f2 %>" style="<%= f2.isEmpty() ? "display:none;" : "" %>">
                        <input type="file" id="f2" accept="image/*" style="display:none" onchange="cargarPreview(this, 'img2', 'txt2', 'foto2Base64')">
                    </div>
                    <div class="photo-uploader" onclick="document.getElementById('f3').click()">
                        <span id="txt3" style="<%= !f3.isEmpty() ? "display:none;" : "" %>">📷 Cargar Foto 3</span>
                        <img id="img3" src="<%= f3 %>" style="<%= f3.isEmpty() ? "display:none;" : "" %>">
                        <input type="file" id="f3" accept="image/*" style="display:none" onchange="cargarPreview(this, 'img3', 'txt3', 'foto3Base64')">
                    </div>
                </div>
            </div>

            <div class="evidence-right no-print">
                <div class="evidence-title">2. Subida de Carta Responsiva Firmada</div>
                <p style="font-size: 11px; color:#555; margin-bottom: 8px;">
                    Genera la responsiva, imprímela, fírmala en físico y sube la foto/archivo firmado aquí:
                </p>
                <div class="photo-uploader" style="width: 100%; height: 60px;" onclick="document.getElementById('fReporte').click()">
                    <span id="txtReporte" style="<%= !fRep.isEmpty() ? "display:none;" : "" %>">📄 Subir Foto de Carta Responsiva Firmada</span>
                    <img id="imgReporte" src="<%= fRep %>" style="<%= fRep.isEmpty() ? "display:none;" : "" %>">
                    <input type="file" id="fReporte" accept="image/*" style="display:none" onchange="cargarPreview(this, 'imgReporte', 'txtReporte', 'reporteFirmadoBase64')">
                </div>
            </div>
        </div>

        <input type="hidden" name="foto1Base64" id="foto1Base64" value="<%= f1 %>">
        <input type="hidden" name="foto2Base64" id="foto2Base64" value="<%= f2 %>">
        <input type="hidden" name="foto3Base64" id="foto3Base64" value="<%= f3 %>">
        <input type="hidden" name="reporteFirmadoBase64" id="reporteFirmadoBase64" value="<%= fRep %>">

        <!-- Botones Inferiores -->
        <div class="bottom-bar no-print">
            <button type="button" class="btn-atras" onclick="window.history.back()">Atrás</button>
            <div>
                <button type="button" class="btn-responsiva" onclick="abrirModalCarta()">📜 Descargar / Imprimir Carta Responsiva</button>
                <button type="submit" class="btn-guardar">Enviar Reporte a Revisión</button>
            </div>
        </div>

    </form>
</div>

<!-- MODAL CARTA RESPONSIVA -->
<div class="modal-overlay" id="modalCarta">
    <div class="modal-body">
        <button type="button" class="btn-close-modal" onclick="cerrarModalCarta()">✕</button>
        <div style="text-align: center; margin-bottom: 15px;">
            <h2 style="font-size: 16px; font-weight: bold; text-transform: uppercase;">CARTA RESPONSIVA VISITAS ACADÉMICAS</h2>
            <div style="text-align: right; margin-top: 10px; font-size: 13px;">
                Emiliano Zapata, Morelos a <span id="lblDia">__</span> de <span id="lblMes">_________</span> del 20<span id="lblAnio">__</span>.
            </div>
        </div>

        <p style="font-weight: bold; margin-bottom: 10px;">
            UNIVERSIDAD TECNOLÓGICA EMILIANO ZAPATA<br>
            DEL ESTADO DE MORELOS.<br>
            P R E S E N T E
        </p>

        <p style="margin-bottom: 12px; text-align: justify;">
            Por este medio, los suscritos estudiantes del programa educativo de <strong id="lblPrograma">_______________________</strong> y bajo protesta de decir verdad, confirmamos nuestra participación en la visita a " <strong id="lblEmpresa">_______________________</strong> ", a celebrase los días <strong id="lblFechas">_______</strong>, en _______________________; bajo el programa anexo al presente documento.
        </p>

        <p style="margin-bottom: 12px; text-align: justify;">
            Conocedores que la actividad se documentará como una visita de estudio de la Universidad Tecnológica Emiliano Zapata del Estado de Morelos (UTEZ) y debido al horario del encuentro ( _____ a _____ hrs.), declaramos que los traslados y gastos derivados a nuestra participación en el evento antes mencionado los realizaremos con nuestros propios medios y recursos, asimismo que conocemos el alcance del seguro de la empresa que se contrató para el traslado.
        </p>

        <p style="margin-bottom: 8px;">Derivado de lo anterior nos obligamos a:</p>
        <ul style="margin-left: 20px; margin-bottom: 12px;">
            <li>Respetar las reglas impuestas tanto por la UTEZ, como por los organizadores de la salida.</li>
            <li>Buscar siempre estar informado de las actividades grupales programadas.</li>
            <li>Abstenerme de cualquier conducta ilegal o inapropiada que pueda denigrar la buena imagen de la UTEZ o que sea perjudicial para sus objetivos y;</li>
            <li>No poner en riesgo mi integridad física ni la de mis compañeros.</li>
        </ul>

        <p style="margin-bottom: 12px; text-align: justify;">
            Estamos de acuerdo en asumir la responsabilidad como ciudadanos y como miembros de la comunidad universitaria, por lo que nos obligamos a realizar las siguientes acciones:
        </p>

        <p style="margin-bottom: 12px; text-align: justify;">
            Adoptar las medidas de seguridad correspondientes de la actividad que desempeñemos en cualquier lugar, tales como uso adecuado de equipo de protección personal, higiene respiratoria, lavado de manos, etc. Así como, seguir los protocolos de prevención emitidos por la Universidad o institución donde esté realizando la actividad de visita de estudio, dentro o fuera del Estado de Morelos.
        </p>

        <p style="margin-bottom: 12px; text-align: justify;">
            Asimismo, manifestamos que la actividad descrita la realizamos bajo nuestra responsabilidad, por lo que deslindamos a la UTEZ y a su personal docente y administrativo de toda responsabilidad en caso de que se presente alguna consecuencia que resulte de la falta de acción, omisión o incumplimiento en la que hayamos incurrido con respecto a los puntos descritos anteriormente, así como del pago de daños y perjuicios y cualquier acción legal, en el entendido que mediante las acciones anteriores la Universidad está protegiendo nuestra integridad y la de los demás miembros de la comunidad universitaria.
        </p>

        <p style="font-style: italic; margin-bottom: 15px; text-align: justify;">
            He leído este documento, entiendo completamente sus términos y por medio del mismo eximo y libero de toda responsabilidad a la UTEZ y a terceros, y me hago único y absoluto responsable de mi persona, en los términos del presente, mismo que suscribo libre y voluntariamente.
        </p>

        <table class="carta-table">
            <thead>
            <tr style="background:#f2f2f2;">
                <th style="width: 10%;">No.</th>
                <th style="width: 40%;">Nombre</th>
                <th style="width: 25%;">Grado y Grupo</th>
                <th style="width: 25%;">Firma</th>
            </tr>
            </thead>
            <tbody>
            <tr><td>1</td><td></td><td></td><td></td></tr>
            <tr><td>2</td><td></td><td></td><td></td></tr>
            <tr><td>3</td><td></td><td></td><td></td></tr>
            <tr><td>4</td><td></td><td></td><td></td></tr>
            </tbody>
        </table>

        <div style="margin-top: 20px; text-align: right;" class="no-print">
            <button type="button" class="btn-pdf" onclick="window.print()">🖨 Imprimir / Descargar en PDF</button>
        </div>
    </div>
</div>

<script>
    function cargarPreview(input, imgId, txtId, hiddenId) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function (e) {
                document.getElementById(imgId).src = e.target.result;
                document.getElementById(imgId).style.display = 'block';
                document.getElementById(txtId).style.display = 'none';
                document.getElementById(hiddenId).value = e.target.result;
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    function abrirModalCarta() {
        actualizarCamposResponsiva();
        document.getElementById('modalCarta').style.display = 'flex';
    }

    function cerrarModalCarta() {
        document.getElementById('modalCarta').style.display = 'none';
    }

    function actualizarCamposResponsiva() {
        const fechaSol = document.getElementById('fechaSolicitud').value;
        if(fechaSol) {
            const partes = fechaSol.split('/');
            if(partes.length === 3) {
                document.getElementById('lblDia').innerText = partes[0];
                document.getElementById('lblMes').innerText = partes[1];
                document.getElementById('lblAnio').innerText = partes[2].slice(-2);
            }
        }

        const prog = document.getElementById('progEdu1').value;
        if(prog) document.getElementById('lblPrograma').innerText = prog;

        const emp = document.getElementById('empresaNom').value;
        if(emp) document.getElementById('lblEmpresa').innerText = emp;

        const fi = document.getElementById('fechaIni').value;
        const ff = document.getElementById('fechaFin').value;
        if(fi || ff) document.getElementById('lblFechas').innerText = (fi + ' al ' + ff);
    }
</script>
</body>
</html>