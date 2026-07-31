<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nueva Solicitud - AWGVA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
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

        /* Layout con espacio para sidebar fijo (240px) */
        .main-layout {
            margin-left: 240px;
            padding: 2.5rem 4rem;
            background-color: #ffffff;
            min-height: 100vh;
        }

        /* Encabezado */
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

        /* Subtítulos de Secciones */
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

        .section-header i {
            font-size: 1.3rem;
        }

        /* Labels */
        .form-label-custom {
            font-size: 0.85rem;
            font-weight: 700;
            color: #1e3a5f;
            margin-bottom: 0.4rem;
            display: block;
        }

        /* Campos estilo gris claro/azul del mockup */
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

        .custom-input::placeholder {
            color: #94a3b8;
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
            font-size: 1rem;
        }

        .input-icon-wrapper .custom-input {
            padding-left: 2.2rem;
        }

        /* Tablas personalizadas */
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

        /* Botón de Enviar */
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
            transition: background-color 0.2s;
        }

        .btn-submit:hover {
            background-color: #d9700f;
            color: #ffffff;
        }

        .btn-cancel {
            color: #334155;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .btn-cancel:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<!-- Sidebar Fijo -->
<jsp:include page="Layout/sidebar.jsp"/>

<main class="main-layout">
    <!-- Encabezado con Logo UTEZ -->
    <div class="header-title-container">
        <h1 class="main-title">SOLICITUD DE VISITAS ACADÉMICAS</h1>
        <!-- Logo UTEZ -->
        <img src="https://upload.wikimedia.org/wikipedia/commons/b/b3/Logo-utez.png" alt="UTEZ Logo" class="utez-logo" onerror="this.style.display='none'">
    </div>

    <form action="solicitud-servlet" method="post">

        <!-- SECCIÓN 1: Datos del Solicitante -->
        <div class="section-header">
            <i class="bi bi-person-badge"></i>
            <span>Datos del Solicitante</span>
        </div>

        <div class="row g-3 mb-3">
            <div class="col-md-6">
                <label class="form-label-custom">Nombre Completo *</label>
                <input type="text" class="custom-input" name="docenteEncargado" placeholder="Nombre y Apellido del solicitante" required>
            </div>
            <div class="col-md-6">
                <label class="form-label-custom">Cargo / Rol *</label>
                <input type="text" class="custom-input" name="tituloVisita" placeholder="Cargo en la Institución" required>
            </div>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-md-6">
                <label class="form-label-custom">Teléfono de contacto *</label>
                <div class="input-icon-wrapper">
                    <i class="bi bi-telephone"></i>
                    <input type="tel" class="custom-input" name="telefonoEmpresa" placeholder="Teléfono del Solicitante" required>
                </div>
            </div>
            <div class="col-md-6">
                <label class="form-label-custom">No. de Docentes acompañantes</label>
                <input type="number" class="custom-input" name="docenteAcompanante" placeholder="Máximo 3 acompañantes" min="0" max="3">
            </div>
        </div>

        <!-- SECCIÓN 2: Datos de la visita -->
        <div class="section-header">
            <i class="bi bi-geo-alt"></i>
            <span>Datos de la visita</span>
        </div>

        <div class="row g-3 mb-3">
            <div class="col-md-6">
                <label class="form-label-custom">Dirección del lugar de la visitar *</label>
                <input type="text" class="custom-input" name="direccionEmpresa" placeholder="Ubicación del lugar de la visita" required>
            </div>
            <div class="col-md-6">
                <label class="form-label-custom">Nombre de la empresa a visitar *</label>
                <input type="text" class="custom-input" name="nombreEmpresa" placeholder="Nombre del lugar a visitar" required>
            </div>
        </div>

        <div class="row g-3 mb-3">
            <div class="col-md-6">
                <label class="form-label-custom">Teléfono de contacto *</label>
                <div class="input-icon-wrapper">
                    <i class="bi bi-telephone"></i>
                    <input type="tel" class="custom-input" name="contacto" placeholder="Telefono del lugar a visitar" required>
                </div>
            </div>
            <div class="col-md-6">
                <label class="form-label-custom">Correo electrónico del lugar de la visita *</label>
                <input type="email" class="custom-input" name="correoEmpresa" placeholder="empresa@com.mx" required>
            </div>
        </div>

        <div class="row g-3 mb-3">
            <div class="col-md-4">
                <label class="form-label-custom">Fecha de inicio *</label>
                <input type="date" class="custom-input" name="fechaInicio" required>
            </div>
            <div class="col-md-4">
                <label class="form-label-custom">Fecha de término *</label>
                <input type="date" class="custom-input" name="fechaFin" required>
            </div>
            <div class="col-md-4">
                <label class="form-label-custom">Hora inicio *</label>
                <input type="time" class="custom-input" name="horaInicio" required>
            </div>
        </div>

        <div class="mb-4">
            <label class="form-label-custom">Objetivo de la visita *</label>
            <textarea class="custom-input" name="proposito" rows="3" placeholder="Describir detalladamente el objetivo para la visita" required></textarea>
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
                    <td><input type="number" name="estudiantesDACEA" min="0" value="0"></td>
                    <td><input type="number" name="estudiantesDATEFI" min="0" value="0"></td>
                    <td><input type="number" name="estudiantesDATID" min="0" value="0"></td>
                    <td><input type="number" name="estudiantesDAMI" min="0" value="0"></td>
                    <td><input type="number" id="totalEstudiantes" name="numeroEstudiantes" readonly style="font-weight: bold;"></td>
                </tr>
                </tbody>
            </table>
        </div>

        <!-- SECCIÓN 3: Información Exclusiva (Grupos y Asignaturas) -->
        <p class="text-secondary small fw-semibold mt-4 mb-2">La siguiente información es de llenado exclusivo para visita académica</p>

        <!-- Tabla de Grupos/Programa Educativo -->
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
                    <td><input type="text" name="programaEducativo" placeholder="Ej. TSU Tecnologías"></td>
                    <td><input type="text" name="semestre" placeholder="Ej. 5to"></td>
                    <td><input type="text" name="nombreGrupo" placeholder="Ej. A"></td>
                    <td><input type="number" name="cantGrupo1" min="0"></td>
                </tr>
                <tr>
                    <td><input type="text" name="programaEducativo2"></td>
                    <td><input type="text" name="semestre2"></td>
                    <td><input type="text" name="nombreGrupo2"></td>
                    <td><input type="number" name="cantGrupo2" min="0"></td>
                </tr>
                <tr>
                    <td><input type="text" name="programaEducativo3"></td>
                    <td><input type="text" name="semestre3"></td>
                    <td><input type="text" name="nombreGrupo3"></td>
                    <td><input type="number" name="cantGrupo3" min="0"></td>
                </tr>
                </tbody>
            </table>
        </div>

        <!-- Asignaturas a Reforzar -->
        <div class="mb-5">
            <label class="form-label-custom">Asignaturas que se reforzarán con la visita *</label>
            <textarea class="custom-input" name="asignatura" rows="3" placeholder="Escriba las asignaturas correspondientes..." required></textarea>
        </div>

        <!-- Botones Inferiores -->
        <div class="d-flex justify-content-between align-items-center pt-3 pb-5">
            <a href="index.jsp" class="btn-cancel">Atrás</a>
            <button type="submit" class="btn-submit">Enviar Solicitud</button>
        </div>

    </form>
</main>

<script>
    // Suma automática de la tabla de estudiantes por división
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
</script>

</body>
</html>