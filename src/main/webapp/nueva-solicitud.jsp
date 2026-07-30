<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nueva Solicitud</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }
        .main-content {
            margin-left: 250px;
            padding: 30px;
            min-height: 100vh;
        }
        .form-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-top: 20px;
        }
        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
        }
        .form-control, .form-select {
            padding: 10px 15px;
            border-radius: 5px;
        }
        .btn-primary {
            background-color: #3498db;
            border-color: #3498db;
            padding: 10px 25px;
        }
        .btn-primary:hover {
            background-color: #2980b9;
            border-color: #2980b9;
        }
        .btn-secondary {
            padding: 10px 25px;
        }
        h5.text-primary {
            color: #3498db !important;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #3498db;
        }
        hr {
            margin: 30px 0;
            border-color: #e0e0e0;
        }
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }
        }
    </style>
</head>
<body>
<jsp:include page="Layout/sidebar.jsp"/>

<div class="main-content">
    <div class="container-fluid">
        <h2 class="mb-4">Nueva Solicitud de Visita Académica</h2>

        <div class="form-container">
            <form action="solicitud-servlet" method="post">
                <!-- Datos de la Visita -->
                <h5 class="text-primary">Información de la Visita</h5>
                <div class="row g-3">
                    <div class="col-12 mb-3">
                        <label for="tituloVisita" class="form-label">Título de la Visita *</label>
                        <input type="text" class="form-control" id="tituloVisita" name="tituloVisita" required>
                    </div>
                </div>

                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="fechaInicio" class="form-label">Fecha de Inicio *</label>
                        <input type="date" class="form-control" id="fechaInicio" name="fechaInicio" required>
                    </div>
                    <div class="col-md-6">
                        <label for="fechaFin" class="form-label">Fecha de Fin *</label>
                        <input type="date" class="form-control" id="fechaFin" name="fechaFin" required>
                    </div>
                </div>

                <div class="row g-3 mt-1">
                    <div class="col-md-6">
                        <label for="asignatura" class="form-label">Asignatura a Reforzar *</label>
                        <input type="text" class="form-control" id="asignatura" name="asignatura" required>
                    </div>
                    <div class="col-md-6">
                        <label for="division" class="form-label">División Académica *</label>
                        <select class="form-select" id="division" name="division" required>
                            <option value="">Seleccionar...</option>
                            <option value="1">DATID</option>
                            <option value="2">DAMI</option>
                            <option value="3">DACEA</option>
                            <option value="4">DATEFI</option>
                        </select>
                    </div>
                </div>

                <div class="row g-3 mt-1">
                    <div class="col-md-6">
                        <label for="docenteEncargado" class="form-label">Docente Encargado *</label>
                        <input type="text" class="form-control" id="docenteEncargado" name="docenteEncargado" required>
                    </div>
                    <div class="col-md-6">
                        <label for="docenteAcompanante" class="form-label">Docente Acompañante</label>
                        <input type="text" class="form-control" id="docenteAcompanante" name="docenteAcompanante">
                    </div>
                </div>

                <div class="mb-3 mt-3">
                    <label for="proposito" class="form-label">Propósito de la Visita *</label>
                    <textarea class="form-control" id="proposito" name="proposito" rows="4" required></textarea>
                </div>

                <hr>

                <!-- Datos de la Empresa -->
                <h5 class="text-primary">Información de la Empresa</h5>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="nombreEmpresa" class="form-label">Nombre de la Empresa *</label>
                        <input type="text" class="form-control" id="nombreEmpresa" name="nombreEmpresa" required>
                    </div>
                    <div class="col-md-6">
                        <label for="telefonoEmpresa" class="form-label">Teléfono</label>
                        <input type="tel" class="form-control" id="telefonoEmpresa" name="telefonoEmpresa">
                    </div>
                </div>

                <div class="row g-3 mt-1">
                    <div class="col-md-6">
                        <label for="correoEmpresa" class="form-label">Correo Electrónico</label>
                        <input type="email" class="form-control" id="correoEmpresa" name="correoEmpresa">
                    </div>
                    <div class="col-md-6">
                        <label for="contacto" class="form-label">Persona de Contacto</label>
                        <input type="text" class="form-control" id="contacto" name="contacto">
                    </div>
                </div>

                <div class="mb-3 mt-3">
                    <label for="direccionEmpresa" class="form-label">Dirección</label>
                    <textarea class="form-control" id="direccionEmpresa" name="direccionEmpresa" rows="2"></textarea>
                </div>

                <hr>

                <!-- Datos del Grupo -->
                <h5 class="text-primary">Información del Grupo</h5>
                <div class="row g-3">
                    <div class="col-md-4">
                        <label for="programaEducativo" class="form-label">Programa Educativo *</label>
                        <input type="text" class="form-control" id="programaEducativo" name="programaEducativo" required>
                    </div>
                    <div class="col-md-3">
                        <label for="semestre" class="form-label">Semestre *</label>
                        <select class="form-select" id="semestre" name="semestre" required>
                            <option value="">Seleccionar...</option>
                            <option value="1">1er Semestre</option>
                            <option value="2">2do Semestre</option>
                            <option value="3">3er Semestre</option>
                            <option value="4">4to Semestre</option>
                            <option value="5">5to Semestre</option>
                            <option value="6">6to Semestre</option>
                            <option value="7">7mo Semestre</option>
                            <option value="8">8vo Semestre</option>
                            <option value="9">9no Semestre</option>
                            <option value="10">10mo Semestre</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label for="nombreGrupo" class="form-label">Grupo *</label>
                        <input type="text" class="form-control" id="nombreGrupo" name="nombreGrupo" placeholder="Ej: A, B, C" required>
                    </div>
                    <div class="col-md-3">
                        <label for="numeroEstudiantes" class="form-label">N° Estudiantes *</label>
                        <input type="number" class="form-control" id="numeroEstudiantes" name="numeroEstudiantes" min="1" required>
                    </div>
                </div>

                <div class="d-flex justify-content-between mt-4">
                    <a href="index.jsp" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Cancelar
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>Guardar Solicitud
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>