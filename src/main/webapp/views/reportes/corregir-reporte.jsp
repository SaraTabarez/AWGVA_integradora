<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");

    // Procesamiento al enviar el formulario por POST
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        session.setAttribute("fechaSolicitud", request.getParameter("fechaSolicitud"));
        session.setAttribute("areaSolicitante", request.getParameter("areaSolicitante"));
        session.setAttribute("docenteResponsable", request.getParameter("docenteResponsable"));
        session.setAttribute("telefonoDocente", request.getParameter("telefonoDocente"));
        session.setAttribute("docenteAcompanante", request.getParameter("docenteAcompanante"));
        session.setAttribute("divisionParticipante", request.getParameter("divisionParticipante"));

        session.setAttribute("programaEducativo1", request.getParameter("programaEducativo1"));
        session.setAttribute("cuatrimestre1", request.getParameter("cuatrimestre1"));
        session.setAttribute("grupo1", request.getParameter("grupo1"));
        session.setAttribute("numEstudiantes1", request.getParameter("numEstudiantes1"));

        session.setAttribute("programaEducativo2", request.getParameter("programaEducativo2"));
        session.setAttribute("cuatrimestre2", request.getParameter("cuatrimestre2"));
        session.setAttribute("grupo2", request.getParameter("grupo2"));
        session.setAttribute("numEstudiantes2", request.getParameter("numEstudiantes2"));

        session.setAttribute("empresa", request.getParameter("empresa"));
        session.setAttribute("direccionEmpresa", request.getParameter("direccionEmpresa"));
        session.setAttribute("telefonoEmpresa", request.getParameter("telefonoEmpresa"));
        session.setAttribute("correoEmpresa", request.getParameter("correoEmpresa"));
        session.setAttribute("objetivoVisita", request.getParameter("objetivoVisita"));
        session.setAttribute("fechaInicio", request.getParameter("fechaInicio"));
        session.setAttribute("fechaTermino", request.getParameter("fechaTermino"));

        // Guardado de Fotos (Asegura conservar si ya existían en la sesión o si vienen nuevas)
        String f1Param = request.getParameter("foto1Base64");
        String f2Param = request.getParameter("foto2Base64");
        String f3Param = request.getParameter("foto3Base64");
        String fRepParam = request.getParameter("reporteFirmadoBase64");

        if (f1Param != null && !f1Param.trim().isEmpty()) session.setAttribute("foto1Base64", f1Param);
        if (f2Param != null && !f2Param.trim().isEmpty()) session.setAttribute("foto2Base64", f2Param);
        if (f3Param != null && !f3Param.trim().isEmpty()) session.setAttribute("foto3Base64", f3Param);
        if (fRepParam != null && !fRepParam.trim().isEmpty()) session.setAttribute("reporteFirmadoBase64", fRepParam);

        session.setAttribute("estatusReporte", "EN REVISIÓN");

        // Redirección inmediata a Detalles
        response.sendRedirect(request.getContextPath() + "/views/reportes/detalles-reporte.jsp");
        return;
    }

    class Helper {
        String val(HttpSession s, String key) {
            Object v = s.getAttribute(key);
            return (v != null) ? v.toString() : "";
        }
        String req(HttpSession s, String key) {
            Object v = s.getAttribute(key);
            if (v == null || v.toString().trim().isEmpty()) {
                return "<span style='color:red;'>*</span>";
            }
            return "";
        }
    }
    Helper h = new Helper();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Corregir Reporte Docente - UTEZ</title>
    <style>
        * { box-sizing: border-box; font-family: Arial, Helvetica, sans-serif; margin: 0; padding: 0; }
        body { display: flex; background-color: #f4f6f9; color: #333; }

        .sidebar { width: 240px; height: 100vh; background-color: #1b365d; color: white; position: fixed; display: flex; flex-direction: column; justify-content: space-between; padding: 25px 0 20px 0; z-index: 10; }
        .user-profile-top { display: flex; align-items: center; gap: 12px; padding: 0 25px 20px 25px; border-bottom: 1px solid rgba(255, 255, 255, 0.15); margin-bottom: 15px; }
        .user-profile-top svg { width: 36px; height: 36px; fill: #fca311; background: rgba(255,255,255,0.1); border-radius: 50%; padding: 4px; }
        .menu-items { display: flex; flex-direction: column; gap: 10px; }
        .menu-item { display: flex; align-items: center; gap: 12px; color: white; text-decoration: none; padding: 12px 30px; font-size: 15px; font-weight: bold; }
        .menu-item.active { color: #ff8c00; }

        .main-container { margin-left: 240px; width: calc(100% - 240px); background-color: #ffffff; padding: 20px 40px 40px 40px; min-height: 100vh; }
        .location-badge { background-color: #fef2f2; color: #991b1b; font-size: 12px; font-weight: bold; padding: 6px 12px; border-radius: 4px; display: inline-block; margin-bottom: 15px; border-left: 4px solid #ef4444; }

        .stepper-box { border: 1px solid #777; border-radius: 4px; padding: 10px; margin-bottom: 25px; }
        .stepper { display: flex; justify-content: space-between; align-items: flex-start; position: relative; }
        .stepper-line { position: absolute; top: 20px; left: 30px; right: 30px; height: 2px; background-color: #ccc; z-index: 1; }
        .step { position: relative; z-index: 2; text-align: center; width: 80px; }
        .step-icon { width: 36px; height: 36px; border-radius: 50%; background-color: #e59339; color: white; margin: 0 auto 5px auto; display: flex; align-items: center; justify-content: center; font-size: 14px; font-weight: bold; }
        .step-text { font-size: 10px; color: #333; }

        .header-section { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; }
        .header-title { font-size: 22px; font-weight: bold; color: #1e3a5f; text-transform: uppercase; }
        .logo-utez { text-align: right; font-weight: bold; font-size: 20px; color: #002b49; }

        .section-box { border: 2px solid #ef4444; border-radius: 4px; padding: 15px; margin-bottom: 25px; }
        .section-title { font-size: 18px; color: #2c4a6f; margin-bottom: 12px; font-weight: bold; }

        .form-grid { display: grid; gap: 12px 15px; margin-bottom: 10px; }
        .grid-2 { grid-template-columns: 2fr 1fr; }
        .grid-3 { grid-template-columns: 1fr 1fr 1fr; }
        .grid-4 { grid-template-columns: 2fr 1fr 1fr 1fr; }

        .form-group { display: flex; flex-direction: column; }
        .form-group label { font-size: 12px; font-weight: bold; color: #1e3a5f; margin-bottom: 4px; }
        .form-group input { background-color: #fef2f2; border: 1px solid #fca5a5; border-radius: 4px; padding: 8px 12px; font-size: 13px; color: #333; outline: none; }
        .form-group input:focus { border-color: #ef4444; background-color: #fff; }

        .evidence-box { border: 1px solid #777; padding: 15px; margin-top: 20px; margin-bottom: 30px; display: flex; justify-content: space-between; gap: 20px; }
        .photos-container { display: flex; gap: 12px; margin-top: 10px; }
        .photo-uploader { width: 120px; height: 80px; border: 1px dashed #ef4444; border-radius: 4px; background: #fff5f5; display: flex; flex-direction: column; align-items: center; justify-content: center; cursor: pointer; text-align: center; font-size: 10px; position: relative; overflow: hidden; }
        .photo-uploader img { width: 100%; height: 100%; object-fit: cover; position: absolute; top:0; left:0; }

        .bottom-bar { display: flex; justify-content: space-between; align-items: center; margin-top: 20px; }
        .btn-atras { background-color: #fca311; color: white; border: none; padding: 10px 30px; border-radius: 6px; font-weight: bold; cursor: pointer; }
        .btn-guardar { background-color: #ef4444; color: white; border: none; padding: 10px 25px; border-radius: 6px; font-weight: bold; cursor: pointer; }
        .btn-guardar:hover { background-color: #dc2626; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="user-profile-top">
        <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
        <div>
            <div style="font-weight:bold; font-size:14px;">Docente Activo</div>
            <div style="font-size:11px; color:#cbd5e1;">Profesor</div>
        </div>
    </div>
    <nav class="menu-items">
        <a href="#" class="menu-item">Inicio</a>
        <a href="#" class="menu-item">Solicitud</a>
        <a href="#" class="menu-item active">Reporte</a>
        <a href="#" class="menu-item">Histórico</a>
    </nav>
</div>

<div class="main-container">

    <div class="location-badge">⚠️ Modo de Corrección: Completa o modifica los campos marcados con (*)</div>

    <div class="stepper-box">
        <div class="stepper">
            <div class="stepper-line"></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Solicitud creada</div></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Solicitud enviada</div></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Solicitud aceptada</div></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Carta responsiva enviada</div></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Carta responsiva aceptada</div></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Visita en curso</div></div>
            <div class="step"><div class="step-icon">✓</div><div class="step-text">Llenar Reporte</div></div>
            <div class="step"><div class="step-icon">!</div><div class="step-text">Reporte a Corregir</div></div>
            <div class="step"><div class="step-icon" style="background:#ccc;"></div><div class="step-text">Visita concretada</div></div>
        </div>
    </div>

    <form id="formCorregir" action="${pageContext.request.contextPath}/views/reportes/corregir-reporte.jsp" method="post">

        <div class="header-section">
            <div>
                <h1 class="header-title">CORREGIR REPORTE DE VISITA ACADÉMICA</h1>
                <div style="margin-top: 15px;">
                    <div class="form-group" style="width: 240px;">
                        <label>Fecha de solicitud <%= h.req(session, "fechaSolicitud") %>:</label>
                        <input type="text" name="fechaSolicitud" value="<%= h.val(session, "fechaSolicitud") %>">
                    </div>
                </div>
            </div>
            <div>
                <div class="logo-utez">UTEZ</div>
                <div style="font-size:12px; font-weight:bold; margin-top:10px;">FO-UTEZ-EST-08<br>rev.08</div>
            </div>
        </div>

        <div class="section-box">
            <div class="section-title">Datos de los participantes y Responsables</div>

            <div class="form-grid grid-3">
                <div class="form-group"><label>Área del solicitante <%= h.req(session, "areaSolicitante") %>:</label><input type="text" name="areaSolicitante" value="<%= h.val(session, "areaSolicitante") %>"></div>
                <div class="form-group"><label>Docente responsable <%= h.req(session, "docenteResponsable") %>:</label><input type="text" name="docenteResponsable" value="<%= h.val(session, "docenteResponsable") %>"></div>
                <div class="form-group"><label>Teléfono de contacto <%= h.req(session, "telefonoDocente") %>:</label><input type="text" name="telefonoDocente" value="<%= h.val(session, "telefonoDocente") %>"></div>
            </div>

            <div class="form-grid grid-2">
                <div class="form-group"><label>Docente acompañante <%= h.req(session, "docenteAcompanante") %>:</label><input type="text" name="docenteAcompanante" value="<%= h.val(session, "docenteAcompanante") %>"></div>
                <div class="form-group"><label>División o área del participante <%= h.req(session, "divisionParticipante") %>:</label><input type="text" name="divisionParticipante" value="<%= h.val(session, "divisionParticipante") %>"></div>
            </div>

            <div class="form-grid grid-4">
                <div class="form-group"><label>Programa educativo <%= h.req(session, "programaEducativo1") %>:</label><input type="text" name="programaEducativo1" value="<%= h.val(session, "programaEducativo1") %>"></div>
                <div class="form-group"><label>Cuatrimestre <%= h.req(session, "cuatrimestre1") %>:</label><input type="text" name="cuatrimestre1" value="<%= h.val(session, "cuatrimestre1") %>"></div>
                <div class="form-group"><label>Grupo <%= h.req(session, "grupo1") %>:</label><input type="text" name="grupo1" value="<%= h.val(session, "grupo1") %>"></div>
                <div class="form-group"><label>Nu. de Estudiantes <%= h.req(session, "numEstudiantes1") %>:</label><input type="text" name="numEstudiantes1" value="<%= h.val(session, "numEstudiantes1") %>"></div>
            </div>

            <div class="form-grid grid-4">
                <div class="form-group"><label>Programa educativo <%= h.req(session, "programaEducativo2") %>:</label><input type="text" name="programaEducativo2" value="<%= h.val(session, "programaEducativo2") %>"></div>
                <div class="form-group"><label>Cuatrimestre <%= h.req(session, "cuatrimestre2") %>:</label><input type="text" name="cuatrimestre2" value="<%= h.val(session, "cuatrimestre2") %>"></div>
                <div class="form-group"><label>Grupo <%= h.req(session, "grupo2") %>:</label><input type="text" name="grupo2" value="<%= h.val(session, "grupo2") %>"></div>
                <div class="form-group"><label>Nu. de Estudiantes <%= h.req(session, "numEstudiantes2") %>:</label><input type="text" name="numEstudiantes2" value="<%= h.val(session, "numEstudiantes2") %>"></div>
            </div>
        </div>

        <div class="section-title">Datos del lugar a visitar</div>

        <div class="form-grid grid-3">
            <div class="form-group"><label>Nombre de la empresa <%= h.req(session, "empresa") %>:</label><input type="text" name="empresa" value="<%= h.val(session, "empresa") %>"></div>
            <div class="form-group"><label>Lugar o dirección <%= h.req(session, "direccionEmpresa") %>:</label><input type="text" name="direccionEmpresa" value="<%= h.val(session, "direccionEmpresa") %>"></div>
            <div class="form-group"><label>Teléfono de contacto <%= h.req(session, "telefonoEmpresa") %>:</label><input type="text" name="telefonoEmpresa" value="<%= h.val(session, "telefonoEmpresa") %>"></div>
        </div>

        <div class="form-grid grid-4">
            <div class="form-group"><label>Correo electrónico <%= h.req(session, "correoEmpresa") %>:</label><input type="text" name="correoEmpresa" value="<%= h.val(session, "correoEmpresa") %>"></div>
            <div class="form-group"><label>Objetivo de la visita <%= h.req(session, "objetivoVisita") %>:</label><input type="text" name="objetivoVisita" value="<%= h.val(session, "objetivoVisita") %>"></div>
            <div class="form-group"><label>Fecha de inicio <%= h.req(session, "fechaInicio") %>:</label><input type="text" name="fechaInicio" value="<%= h.val(session, "fechaInicio") %>"></div>
            <div class="form-group"><label>Fecha de término <%= h.req(session, "fechaTermino") %>:</label><input type="text" name="fechaTermino" value="<%= h.val(session, "fechaTermino") %>"></div>
        </div>

        <!-- Evidencias Fotográficas -->
        <div class="evidence-box">
            <div style="flex: 1.5;">
                <div style="font-weight:bold; color:#ef4444; margin-bottom:10px;">1. Modificar Fotografías (Evidencias)</div>
                <div class="photos-container">
                    <%
                        String f1 = h.val(session, "foto1Base64");
                        String f2 = h.val(session, "foto2Base64");
                        String f3 = h.val(session, "foto3Base64");
                        String fRep = h.val(session, "reporteFirmadoBase64");
                    %>
                    <div class="photo-uploader" onclick="document.getElementById('f1').click()">
                        <span id="txt1" style="<%= !f1.isEmpty() ? "display:none;" : "" %>">📷 Foto 1</span>
                        <img id="img1" src="<%= f1 %>" style="<%= f1.isEmpty() ? "display:none;" : "" %>">
                        <input type="file" id="f1" accept="image/*" style="display:none" onchange="cargarPreview(this, 'img1', 'txt1', 'foto1Base64')">
                    </div>
                    <div class="photo-uploader" onclick="document.getElementById('f2').click()">
                        <span id="txt2" style="<%= !f2.isEmpty() ? "display:none;" : "" %>">📷 Foto 2</span>
                        <img id="img2" src="<%= f2 %>" style="<%= f2.isEmpty() ? "display:none;" : "" %>">
                        <input type="file" id="f2" accept="image/*" style="display:none" onchange="cargarPreview(this, 'img2', 'txt2', 'foto2Base64')">
                    </div>
                    <div class="photo-uploader" onclick="document.getElementById('f3').click()">
                        <span id="txt3" style="<%= !f3.isEmpty() ? "display:none;" : "" %>">📷 Foto 3</span>
                        <img id="img3" src="<%= f3 %>" style="<%= f3.isEmpty() ? "display:none;" : "" %>">
                        <input type="file" id="f3" accept="image/*" style="display:none" onchange="cargarPreview(this, 'img3', 'txt3', 'foto3Base64')">
                    </div>
                </div>
            </div>

            <div style="flex: 1; border-left:1px solid #ddd; padding-left:20px;">
                <div style="font-weight:bold; color:#ef4444; margin-bottom:10px;">2. Modificar Carta Responsiva Firmada</div>
                <div class="photo-uploader" style="width: 100%; height: 60px;" onclick="document.getElementById('fReporte').click()">
                    <span id="txtReporte" style="<%= !fRep.isEmpty() ? "display:none;" : "" %>">📄 Subir Nueva Foto</span>
                    <img id="imgReporte" src="<%= fRep %>" style="<%= fRep.isEmpty() ? "display:none;" : "" %>">
                    <input type="file" id="fReporte" accept="image/*" style="display:none" onchange="cargarPreview(this, 'imgReporte', 'txtReporte', 'reporteFirmadoBase64')">
                </div>
            </div>
        </div>

        <input type="hidden" name="foto1Base64" id="foto1Base64" value="<%= f1 %>">
        <input type="hidden" name="foto2Base64" id="foto2Base64" value="<%= f2 %>">
        <input type="hidden" name="foto3Base64" id="foto3Base64" value="<%= f3 %>">
        <input type="hidden" name="reporteFirmadoBase64" id="reporteFirmadoBase64" value="<%= fRep %>">

        <div class="bottom-bar">
            <button type="button" class="btn-atras" onclick="window.history.back()">Atrás</button>
            <button type="submit" class="btn-guardar">Reenviar Reporte Corregido</button>
        </div>

    </form>
</div>

<script>
    function cargarPreview(input, imgId, txtId, hiddenId) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function (e) {
                document.getElementById(imgId).src = e.target.result;
                document.getElementById(imgId).style.display = 'block';
                if(document.getElementById(txtId)) document.getElementById(txtId).style.display = 'none';
                document.getElementById(hiddenId).value = e.target.result;
            }
            reader.readAsDataURL(input.files[0]);
        }
    }
</script>
</body>
</html>