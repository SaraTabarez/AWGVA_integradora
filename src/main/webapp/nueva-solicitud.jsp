<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nueva Solicitud - AWGVA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Librería para convertir HTML a PDF de forma exacta -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: #ffffff;
            color: #1e3a5f;
            min-height: 100vh;
        }

        .main-layout {
            margin-left: 240px;
            padding: 2.5rem 4rem;
            background-color: #ffffff;
            min-height: 100vh;
        }

        .header-title-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .main-title {
            color: #1e3a5f;
            font-weight: 800;
            font-size: 1.8rem;
            letter-spacing: -0.5px;
            margin: 0;
        }

        .utez-logo {
            height: 45px;
            object-fit: contain;
        }

        .section-header {
            color: #1e3a5f;
            font-weight: 700;
            font-size: 1.2rem;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 1.5rem;
            margin-bottom: 1.2rem;
        }

        .form-label-custom {
            font-size: 0.85rem;
            font-weight: 700;
            color: #1e3a5f;
            margin-bottom: 0.4rem;
            display: block;
        }

        .custom-input {
            background-color: #e2e8f0;
            border: 1px solid transparent;
            border-radius: 6px;
            padding: 0.55rem 0.8rem;
            width: 100%;
            color: #333333;
            font-size: 0.9rem;
            outline: none;
            transition: all 0.2s ease-in-out;
        }

        .custom-input:focus {
            background-color: #ffffff;
            border-color: #f38218;
            box-shadow: 0 0 0 0.2rem rgba(243, 130, 24, 0.15);
        }

        .input-icon-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-icon-wrapper i {
            position: absolute;
            left: 12px;
            color: #8a99ad;
        }

        .input-icon-wrapper .custom-input {
            padding-left: 2.2rem;
        }

        .custom-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 0.5rem;
        }

        .custom-table th {
            border: 1px solid #1e3a5f;
            color: #1e3a5f;
            font-size: 0.85rem;
            font-weight: 700;
            text-align: center;
            padding: 6px 8px;
            background-color: #ffffff;
        }

        .custom-table td {
            border: 1px solid #1e3a5f;
            padding: 0;
            background-color: #e2e8f0;
        }

        .custom-table td input {
            width: 100%;
            border: none;
            background: transparent;
            padding: 8px;
            text-align: center;
            outline: none;
            font-size: 0.9rem;
            color: #333;
        }

        /* Estilo Botón Habilitado / Deshabilitado */
        .btn-submit {
            background-color: #f38218;
            color: #ffffff;
            border: none;
            border-radius: 6px;
            padding: 0.65rem 2rem;
            font-weight: 600;
            font-size: 0.95rem;
            cursor: pointer;
            box-shadow: 0 2px 4px rgba(243, 130, 24, 0.2);
            transition: all 0.2s ease;
        }

        .btn-submit:hover:not(:disabled) {
            background-color: #d9700f;
        }

        .btn-submit:disabled {
            background-color: #cbd5e1;
            color: #94a3b8;
            cursor: not-allowed;
            box-shadow: none;
        }

        .btn-cancel {
            color: #334155;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
        }

        /* CONFIGURACIÓN DEL PLANTILLA PARA EL PDF OCULTO */
        #pdfTemplate {
            display: none; /* Oculto en la pantalla web normal */
            width: 750px;
            padding: 30px;
            background-color: #ffffff;
            font-family: Arial, sans-serif;
            color: #000;
        }

        .pdf-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid #000;
            padding-bottom: 10px;
            margin-bottom: 15px;
        }

        .pdf-title {
            font-weight: bold;
            font-size: 18px;
        }

        .pdf-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 15px;
        }

        .pdf-table th, .pdf-table td {
            border: 1px solid #000;
            padding: 6px 8px;
            font-size: 11px;
        }

        .pdf-table th {
            font-weight: bold;
            background-color: #f2f2f2;
        }

        .pdf-section-title {
            font-weight: bold;
            font-size: 13px;
            margin-top: 15px;
            margin-bottom: 5px;
        }

        .pdf-signatures {
            display: flex;
            justify-content: space-around;
            margin-top: 80px;
            text-align: center;
        }

        .pdf-signature-line {
            width: 250px;
            border-top: 1px solid #000;
            padding-top: 5px;
            font-size: 11px;
            font-weight: bold;
        }
    </style>
</head>
<body>

<jsp:include page="Layout/sidebar.jsp"/>

<main class="main-layout">
    <div class="header-title-container">
        <h1 class="main-title">SOLICITUD DE VISITAS ACADÉMICAS</h1>
        <img src="https://upload.wikimedia.org/wikipedia/commons/b/b3/Logo-utez.png" alt="UTEZ Logo" class="utez-logo" onerror="this.style.display='none'">
    </div>

    <!-- Formulario principal con los inputs obligatorios (required) -->
    <form id="solicitudForm" action="solicitud-servlet" method="post">

        <!-- SECCIÓN 1: Datos del Solicitante -->
        <div class="section-header">
            <i class="bi bi-person-badge"></i>
            <span>Datos del Solicitante</span>
        </div>

        <div class="row g-3 mb-3">
            <div class="col-md-6">
                <label class="form-label-custom">Nombre Completo *</label>
                <input type="text" class="custom-input required-field" id="docenteEncargado" name="docenteEncargado" placeholder="Nombre y Apellido del solicitante" required>
            </div>
            <div class="col-md-6">
                <label class="form-label-custom">Cargo / Rol *</label>
                <input type="text" class="custom-input required-field" id="tituloVisita" name="tituloVisita" placeholder="Cargo en la Institución" required>
            </div>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-md-6">
                <label class="form-label-custom">Teléfono de contacto *</label>
                <div class="input-icon-wrapper">
                    <i class="bi bi-telephone"></i>
                    <input type="tel" class="custom-input required-field" id="telefonoDocente" name="telefonoEmpresa" placeholder="Teléfono del Solicitante" required>
                </div>
            </div>
            <div class="col-md-6">
                <label class="form-label-custom">No. de Docentes acompañantes</label>
                <input type="number" class="custom-input" id="docenteAcompanante" name="docenteAcompanante" placeholder="Máximo 3 acompañantes" min="0" max="3">
            </div>
        </div>

        <!-- SECCIÓN 2: Datos de la visita -->
        <div class="section-header">
            <i class="bi bi-geo-alt"></i>
            <span>Datos de la visita</span>
        </div>

        <div class="row g-3 mb-3">
            <div class="col-md-6">
                <label class="form-label-custom">Dirección del lugar a visitar *</label>
                <input type="text" class="custom-input required-field" id="direccionEmpresa" name="direccionEmpresa" placeholder="Ubicación del lugar de la visita" required>
            </div>
            <div class="col-md-6">
                <label class="form-label-custom">Nombre de la empresa a visitar *</label>
                <input type="text" class="custom-input required-field" id="nombreEmpresa" name="nombreEmpresa" placeholder="Nombre del lugar a visitar" required>
            </div>
        </div>

        <div class="row g-3 mb-3">
            <div class="col-md-6">
                <label class="form-label-custom">Teléfono de contacto *</label>
                <div class="input-icon-wrapper">
                    <i class="bi bi-telephone"></i>
                    <input type="tel" class="custom-input required-field" id="contacto" name="contacto" placeholder="Telefono del lugar a visitar" required>
                </div>
            </div>
            <div class="col-md-6">
                <label class="form-label-custom">Correo electrónico del lugar de la visita *</label>
                <input type="email" class="custom-input required-field" id="correoEmpresa" name="correoEmpresa" placeholder="empresa@com.mx" required>
            </div>
        </div>

        <div class="row g-3 mb-3">
            <div class="col-md-4">
                <label class="form-label-custom">Fecha de inicio *</label>
                <input type="date" class="custom-input required-field" id="fechaInicio" name="fechaInicio" required>
            </div>
            <div class="col-md-4">
                <label class="form-label-custom">Fecha de término *</label>
                <input type="date" class="custom-input required-field" id="fechaFin" name="fechaFin" required>
            </div>
            <div class="col-md-4">
                <label class="form-label-custom">Hora inicio *</label>
                <input type="time" class="custom-input required-field" id="horaInicio" name="horaInicio" required>
            </div>
        </div>

        <div class="mb-4">
            <label class="form-label-custom">Objetivo de la visita *</label>
            <textarea class="custom-input required-field" id="proposito" name="proposito" rows="3" placeholder="Describir detalladamente el objetivo para la visita" required></textarea>
        </div>

        <!-- Tabla Estudiantes por División -->
        <div class="mb-4">
            <label class="form-label-custom">No. de estudiantes participantes por división academica: *</label>
            <table class="custom-table">
                <thead>
                <tr>
                    <th>DACEA</th>
                    <th>DATEFI</th>
                    <th>DATID</th>
                    <th>DAMI</th>
                    <th>Total estudiantes</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td><input type="number" id="dacea" name="estudiantesDACEA" min="0" value="0"></td>
                    <td><input type="number" id="datefi" name="estudiantesDATEFI" min="0" value="0"></td>
                    <td><input type="number" id="datid" name="estudiantesDATID" min="0" value="0"></td>
                    <td><input type="number" id="dami" name="estudiantesDAMI" min="0" value="0"></td>
                    <td><input type="number" id="totalEstudiantes" name="numeroEstudiantes" readonly style="font-weight: bold;"></td>
                </tr>
                </tbody>
            </table>
        </div>

        <!-- SECCIÓN 3: Información Exclusiva -->
        <p class="text-secondary small fw-semibold mt-4 mb-2">La siguiente información es de llenado exclusivo para visita académica</p>

        <div class="mb-4">
            <table class="custom-table">
                <thead>
                <tr>
                    <th style="width: 40%;">Programa Educativo</th>
                    <th style="width: 20%;">Cuatrimestre</th>
                    <th style="width: 20%;">Grupo</th>
                    <th style="width: 20%;">No. Estudiantes</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td><input type="text" class="required-field" id="prog1" name="programaEducativo" placeholder="Ej. TSU Tecnologías" required></td>
                    <td><input type="text" class="required-field" id="cuatri1" name="semestre" placeholder="Ej. 5to" required></td>
                    <td><input type="text" class="required-field" id="grupo1" name="nombreGrupo" placeholder="Ej. A" required></td>
                    <td><input type="number" class="required-field" id="cant1" name="cantGrupo1" min="0" required></td>
                </tr>
                <tr>
                    <td><input type="text" id="prog2" name="programaEducativo2"></td>
                    <td><input type="text" id="cuatri2" name="semestre2"></td>
                    <td><input type="text" id="grupo2" name="nombreGrupo2"></td>
                    <td><input type="number" id="cant2" name="cantGrupo2" min="0"></td>
                </tr>
                </tbody>
            </table>
        </div>

        <div class="mb-5">
            <label class="form-label-custom">Asignaturas que se reforzarán con la visita *</label>
            <textarea class="custom-input required-field" id="asignatura" name="asignatura" rows="3" placeholder="Escriba las asignaturas correspondientes..." required></textarea>
        </div>

        <!-- Botones Inferiores (El botón Guardar/Descargar estará deshabilitado al inicio) -->
        <div class="d-flex justify-content-between align-items-center pt-3 pb-5">
            <a href="index.jsp" class="btn-cancel">Atrás</a>
            <button type="button" id="btnSubmit" class="btn-submit" disabled>
                <i class="bi bi-download me-2"></i>Guardar y Descargar PDF
            </button>
        </div>

    </form>
</main>

<!-- MOUNT OCULTO: PLANTILLA EXACTA DE LA FOTO DEL DOCUMENTO OFICIAL -->
<div id="pdfTemplate">
    <div class="pdf-header">
        <span class="pdf-title">SOLICITUD DE VISITAS ACADÉMICAS</span>
        <img src="https://upload.wikimedia.org/wikipedia/commons/b/b3/Logo-utez.png" style="height: 35px;">
    </div>

    <div class="pdf-section-title">Datos del Lugar</div>
    <table class="pdf-table">
        <tr>
            <td style="width: 30%; font-weight: bold;">Nombre de la empresa:</td>
            <td id="pdf_nombreEmpresa" style="width: 70%;"></td>
        </tr>
        <tr>
            <td style="font-weight: bold;">Dirección o lugar:</td>
            <td id="pdf_direccionEmpresa"></td>
        </tr>
        <tr>
            <td style="font-weight: bold;">Teléfono de contacto:</td>
            <td id="pdf_contacto"></td>
        </tr>
        <tr>
            <td style="font-weight: bold;">Correo Electrónico:</td>
            <td id="pdf_correoEmpresa"></td>
        </tr>
        <tr>
            <td style="font-weight: bold;">Fecha de inicio de la visita:</td>
            <td><span id="pdf_fechaInicio"></span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b>Hora de inicio:</b> <span id="pdf_horaInicio"></span></td>
        </tr>
        <tr>
            <td style="font-weight: bold;">Fecha de termino de la visita:</td>
            <td id="pdf_fechaFin"></td>
        </tr>
        <tr>
            <td colspan="2">
                <b>Objetivo de la visita:</b><br>
                <div id="pdf_proposito" style="min-height: 40px; margin-top: 4px;"></div>
            </td>
        </tr>
    </table>

    <div class="pdf-section-title">Datos de los Participantes</div>
    <table class="pdf-table">
        <tr>
            <td style="width: 30%; font-weight: bold;">Área solicitante:</td>
            <td id="pdf_tituloVisita" style="width: 70%;"></td>
        </tr>
        <tr>
            <td style="font-weight: bold;">Docente responsable:</td>
            <td id="pdf_docenteEncargado"></td>
        </tr>
        <tr>
            <td style="font-weight: bold;">Celular de responsable:</td>
            <td><span id="pdf_telefonoDocente"></span> &nbsp;&nbsp;&nbsp;&nbsp; <b>Docentes acompañantes:</b> <span id="pdf_docenteAcompanante"></span></td>
        </tr>
    </table>

    <div style="font-size: 11px; font-weight: bold; margin-bottom: 4px;">No. de estudiantes participantes por división academica:</div>
    <table class="pdf-table" style="text-align: center;">
        <thead>
        <tr>
            <th>DACEA</th>
            <th>DATEFI</th>
            <th>DATID</th>
            <th>DAMI</th>
            <th>Total estudiantes</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td id="pdf_dacea">0</td>
            <td id="pdf_datefi">0</td>
            <td id="pdf_datid">0</td>
            <td id="pdf_dami">0</td>
            <td id="pdf_totalEstudiantes">0</td>
        </tr>
        </tbody>
    </table>

    <div style="font-size: 10px; font-style: italic; margin-top: 10px; margin-bottom: 4px;">
        La siguiente información es de llenado exclusivo para visita académica
    </div>

    <table class="pdf-table" style="text-align: center;">
        <thead>
        <tr>
            <th>Programa Educativo</th>
            <th>Cuatrimestre</th>
            <th>Grupo</th>
            <th>No. Estudiantes</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td id="pdf_prog1"></td>
            <td id="pdf_cuatri1"></td>
            <td id="pdf_grupo1"></td>
            <td id="pdf_cant1"></td>
        </tr>
        <tr>
            <td id="pdf_prog2"></td>
            <td id="pdf_cuatri2"></td>
            <td id="pdf_grupo2"></td>
            <td id="pdf_cant2"></td>
        </tr>
        </tbody>
    </table>

    <div style="font-size: 11px; font-weight: bold; margin-top: 10px; margin-bottom: 4px;">Asignaturas que se reforzarán con la visita:</div>
    <div id="pdf_asignatura" style="border: 1px solid #000; padding: 8px; font-size: 11px; min-height: 50px;"></div>

    <div class="pdf-signatures">
        <div>
            <div class="pdf-signature-line">
                Solicita<br><br><br>
                <span id="pdf_sigDocente">________________________</span><br>
                <small style="font-weight: normal;">Nombre del docente responsable de la visita</small>
            </div>
        </div>
        <div>
            <div class="pdf-signature-line">
                Autoriza<br><br><br>
                ________________________<br>
                <small style="font-weight: normal;">Nombre y cargo del director de carrera/titular de área</small>
            </div>
        </div>
    </div>
</div>

<script>
    // 1. CÁLCULO DE TOTAL DE ESTUDIANTES
    const inputsDivision = document.querySelectorAll('input[name^="estudiantes"]');
    const totalInput = document.getElementById('totalEstudiantes');

    function calcularTotal() {
        let suma = 0;
        inputsDivision.forEach(input => {
            const val = parseInt(input.value) || 0;
            suma += val;
        });
        totalInput.value = suma;
    }

    inputsDivision.forEach(input => {
        input.addEventListener('input', calcularTotal);
    });

    // 2. VALIDACIÓN: HABILIAR/DESHABILITAR BOTÓN SI TODOS LOS CAMPOS ESTÁN LLENOS
    const requiredInputs = document.querySelectorAll('.required-field');
    const btnSubmit = document.getElementById('btnSubmit');

    function validarFormulario() {
        let todoLleno = true;
        requiredInputs.forEach(input => {
            if (!input.value.trim()) {
                todoLleno = false;
            }
        });

        btnSubmit.disabled = !todoLleno;
    }

    // Escuchar eventos en cada campo para validar en tiempo real
    requiredInputs.forEach(input => {
        input.addEventListener('input', validarFormulario);
        input.addEventListener('change', validarFormulario);
    });

    // 3. GENERAR Y DESCARGAR PDF BASADO EN EL DOCUMENTO MODELO
    btnSubmit.addEventListener('click', () => {
        // Llenar plantilla PDF con los valores actuales del formulario
        document.getElementById('pdf_nombreEmpresa').innerText = document.getElementById('nombreEmpresa').value;
        document.getElementById('pdf_direccionEmpresa').innerText = document.getElementById('direccionEmpresa').value;
        document.getElementById('pdf_contacto').innerText = document.getElementById('contacto').value;
        document.getElementById('pdf_correoEmpresa').innerText = document.getElementById('correoEmpresa').value;
        document.getElementById('pdf_fechaInicio').innerText = document.getElementById('fechaInicio').value;
        document.getElementById('pdf_horaInicio').innerText = document.getElementById('horaInicio').value;
        document.getElementById('pdf_fechaFin').innerText = document.getElementById('fechaFin').value;
        document.getElementById('pdf_proposito').innerText = document.getElementById('proposito').value;

        document.getElementById('pdf_tituloVisita').innerText = document.getElementById('tituloVisita').value;
        document.getElementById('pdf_docenteEncargado').innerText = document.getElementById('docenteEncargado').value;
        document.getElementById('pdf_telefonoDocente').innerText = document.getElementById('telefonoDocente').value;
        document.getElementById('pdf_docenteAcompanante').innerText = document.getElementById('docenteAcompanante').value || '0';

        document.getElementById('pdf_dacea').innerText = document.getElementById('dacea').value || '0';
        document.getElementById('pdf_datefi').innerText = document.getElementById('datefi').value || '0';
        document.getElementById('pdf_datid').innerText = document.getElementById('datid').value || '0';
        document.getElementById('pdf_dami').innerText = document.getElementById('dami').value || '0';
        document.getElementById('pdf_totalEstudiantes').innerText = document.getElementById('totalEstudiantes').value || '0';

        document.getElementById('pdf_prog1').innerText = document.getElementById('prog1').value;
        document.getElementById('pdf_cuatri1').innerText = document.getElementById('cuatri1').value;
        document.getElementById('pdf_grupo1').innerText = document.getElementById('grupo1').value;
        document.getElementById('pdf_cant1').innerText = document.getElementById('cant1').value;

        document.getElementById('pdf_prog2').innerText = document.getElementById('prog2').value;
        document.getElementById('pdf_cuatri2').innerText = document.getElementById('cuatri2').value;
        document.getElementById('pdf_grupo2').innerText = document.getElementById('grupo2').value;
        document.getElementById('pdf_cant2').innerText = document.getElementById('cant2').value;

        document.getElementById('pdf_asignatura').innerText = document.getElementById('asignatura').value;
        document.getElementById('pdf_sigDocente').innerText = document.getElementById('docenteEncargado').value;

        // Mostrar elemento temporalmente para renderizado del PDF
        const element = document.getElementById('pdfTemplate');
        element.style.display = 'block';

        // Opciones del PDF
        const opt = {
            margin:       0.3,
            filename:     'Solicitud_Visita_Academica.pdf',
            image:        { type: 'jpeg', quality: 0.98 },
            html2canvas:  { scale: 2 },
            jsPDF:        { unit: 'in', format: 'letter', orientation: 'portrait' }
        };

        // Descargar PDF y enviar formulario
        html2pdf().set(opt).from(element).save().then(() => {
            element.style.display = 'none'; // Volver a ocultar
            // Opcional: Descomenta la siguiente línea si deseas enviar el formulario al servlet automáticamente tras descargar
            // document.getElementById('solicitudForm').submit();
        });
    });
</script>

</body>
</html>