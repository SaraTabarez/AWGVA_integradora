<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Documentos Subidos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }
        .main-content {
            margin-left: 250px;
            padding: 30px;
            min-height: 100vh;
        }
        .page-header {
            background: white;
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 25px;
        }
        .page-header h2 {
            margin: 0;
            color: #333;
            font-size: 24px;
            font-weight: 600;
        }
        .stepper {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .step {
            display: flex;
            flex-direction: column;
            align-items: center;
            flex: 1;
            position: relative;
        }
        .step:not(:last-child)::after {
            content: '';
            position: absolute;
            top: 20px;
            left: 50%;
            width: 100%;
            height: 2px;
            background: #e0e0e0;
        }
        .step.completed:not(:last-child)::after {
            background: #ff6b35;
        }
        .step-circle {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #e0e0e0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            color: #666;
            margin-bottom: 8px;
            z-index: 1;
            transition: all 0.3s ease;
        }
        .step.completed .step-circle {
            background: #ff6b35;
            color: white;
        }
        .step.active .step-circle {
            background: #ff6b35;
            color: white;
            box-shadow: 0 0 0 4px rgba(255, 107, 53, 0.2);
        }
        .step-label {
            font-size: 11px;
            text-align: center;
            color: #666;
            max-width: 80px;
            line-height: 1.2;
        }
        .step.completed .step-label {
            color: #ff6b35;
            font-weight: 500;
        }
        .upload-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 25px;
        }
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }
        .section-subtitle {
            font-size: 14px;
            color: #666;
            margin-bottom: 20px;
        }
        .upload-area {
            border: 2px dashed #d0d0d0;
            border-radius: 8px;
            padding: 40px;
            text-align: center;
            background-color: #fafafa;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .upload-area:hover {
            background-color: #f0f0f0;
            border-color: #ff6b35;
        }
        .upload-area i {
            font-size: 48px;
            color: #ff6b35;
            margin-bottom: 15px;
        }
        .upload-area h4 {
            font-size: 16px;
            color: #333;
            margin-bottom: 8px;
        }
        .upload-area p {
            font-size: 13px;
            color: #999;
            margin-bottom: 5px;
        }
        .upload-info {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
            font-size: 13px;
            color: #666;
        }
        .documents-table {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .table {
            margin-bottom: 0;
        }
        .table thead th {
            background-color: #f8f9fa;
            border-bottom: 2px solid #e0e0e0;
            font-weight: 600;
            color: #333;
            font-size: 13px;
            padding: 12px 15px;
        }
        .table tbody td {
            padding: 12px 15px;
            font-size: 13px;
            color: #666;
            vertical-align: middle;
        }
        .badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 500;
        }
        .badge-draft {
            background-color: #fff3cd;
            color: #856404;
        }
        .action-btn {
            background: none;
            border: none;
            color: #666;
            padding: 5px 10px;
            cursor: pointer;
            transition: color 0.3s ease;
        }
        .action-btn:hover {
            color: #ff6b35;
        }
        .action-btn.delete:hover {
            color: #dc3545;
        }
        .navigation-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 25px;
        }
        .btn-custom {
            padding: 10px 30px;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-secondary-custom {
            background-color: #6c757d;
            border-color: #6c757d;
            color: white;
        }
        .btn-secondary-custom:hover {
            background-color: #5a6268;
            border-color: #5a6268;
            color: white;
        }
        .btn-primary-custom {
            background-color: #ff6b35;
            border-color: #ff6b35;
            color: white;
        }
        .btn-primary-custom:hover {
            background-color: #e55a2b;
            border-color: #e55a2b;
            color: white;
        }
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }
            .stepper {
                flex-wrap: wrap;
            }
            .step {
                min-width: 50%;
                margin-bottom: 20px;
            }
        }
    </style>
</head>
<body>
<jsp:include page="Layout/sidebar.jsp"/>

<div class="main-content">
    <div class="container-fluid">
        <div class="page-header">
            <h2>Documentos subidos/responsiva</h2>
        </div>

        <!-- Stepper de progreso -->
        <div class="stepper">
            <div class="step completed">
                <div class="step-circle">1</div>
                <div class="step-label">Solicitud creada</div>
            </div>
            <div class="step completed">
                <div class="step-circle">2</div>
                <div class="step-label">Solicitud enviada</div>
            </div>
            <div class="step completed">
                <div class="step-circle">3</div>
                <div class="step-label">Solicitud aceptada</div>
            </div>
            <div class="step completed">
                <div class="step-circle">4</div>
                <div class="step-label">Carta responsiva enviada</div>
            </div>
            <div class="step completed">
                <div class="step-circle">5</div>
                <div class="step-label">Carta responsiva aceptada</div>
            </div>
            <div class="step completed">
                <div class="step-circle">6</div>
                <div class="step-label">Visita en curso</div>
            </div>
            <div class="step completed">
                <div class="step-circle">7</div>
                <div class="step-label">Reporte enviado</div>
            </div>
            <div class="step">
                <div class="step-circle">8</div>
                <div class="step-label">Reporte aceptado</div>
            </div>
        </div>

        <!-- Sección de upload -->
        <div class="upload-section">
            <h3 class="section-title">Imágenes y Documentos</h3>
            <p class="section-subtitle">Adjunta imágenes (PNG, JPG, WEBP) y documentos (PDF)</p>

            <form action="upload-servlet" method="post" enctype="multipart/form-data">
                <div class="upload-area" id="uploadArea">
                    <i class="fas fa-cloud-upload-alt"></i>
                    <h4>Arrastra archivos aquí o selecciona</h4>
                    <p>Formatos aceptados: PNG, JPG, WEBP, PDF</p>
                    <p>Máx. 10 MB por archivo</p>
                    <input type="file" id="fileInput" name="archivo" class="d-none" multiple accept=".png,.jpg,.jpeg,.webp,.pdf">
                </div>

                <div class="upload-info">
                    <span>1 de 5 archivos</span>
                    <span>69.7 KB de 100 MB</span>
                </div>
            </form>
        </div>

        <!-- Tabla de documentos -->
        <div class="documents-table">
            <h3 class="section-title">Documentos subidos</h3>
            <table class="table">
                <thead>
                <tr>
                    <th>Tipo</th>
                    <th>Nombre</th>
                    <th>Tamaño</th>
                    <th>Fecha</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>Solicitud</td>
                    <td>solicitud_visita.pdf</td>
                    <td>69.7 KB</td>
                    <td>24/09/2026<br><small>18:23 p.m.</small></td>
                    <td><span class="badge badge-draft">Borrador</span></td>
                    <td>
                        <button class="action-btn" title="Ver"><i class="fas fa-eye"></i></button>
                        <button class="action-btn" title="Descargar"><i class="fas fa-download"></i></button>
                        <button class="action-btn delete" title="Eliminar"><i class="fas fa-trash"></i></button>
                    </td>
                </tr>
                <tr>
                    <td>Carta responsiva</td>
                    <td>carta_responsiva.pdf</td>
                    <td>69.7 KB</td>
                    <td>24/09/2026<br><small>18:23 p.m.</small></td>
                    <td><span class="badge badge-draft">Borrador</span></td>
                    <td>
                        <button class="action-btn" title="Ver"><i class="fas fa-eye"></i></button>
                        <button class="action-btn" title="Descargar"><i class="fas fa-download"></i></button>
                        <button class="action-btn delete" title="Eliminar"><i class="fas fa-trash"></i></button>
                    </td>
                </tr>
                <tr>
                    <td>Reporte</td>
                    <td>reporte_visita.pdf</td>
                    <td>69.7 KB</td>
                    <td>24/09/2026<br><small>18:23 p.m.</small></td>
                    <td><span class="badge badge-draft">Borrador</span></td>
                    <td>
                        <button class="action-btn" title="Ver"><i class="fas fa-eye"></i></button>
                        <button class="action-btn" title="Descargar"><i class="fas fa-download"></i></button>
                        <button class="action-btn delete" title="Eliminar"><i class="fas fa-trash"></i></button>
                    </td>
                </tr>
                </tbody>
            </table>

            <div class="navigation-buttons">
                <button class="btn btn-secondary-custom btn-custom">
                    <i class="fas fa-arrow-left me-2"></i>Anterior
                </button>
                <button class="btn btn-primary-custom btn-custom">
                    Subir<i class="fas fa-arrow-right ms-2"></i>
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const uploadArea = document.getElementById('uploadArea');
    const fileInput = document.getElementById('fileInput');

    uploadArea.addEventListener('click', () => {
        fileInput.click();
    });

    uploadArea.addEventListener('dragover', (e) => {
        e.preventDefault();
        uploadArea.style.backgroundColor = '#f0f0f0';
        uploadArea.style.borderColor = '#ff6b35';
    });

    uploadArea.addEventListener('dragleave', () => {
        uploadArea.style.backgroundColor = '#fafafa';
        uploadArea.style.borderColor = '#d0d0d0';
    });

    uploadArea.addEventListener('drop', (e) => {
        e.preventDefault();
        uploadArea.style.backgroundColor = '#fafafa';
        uploadArea.style.borderColor = '#d0d0d0';
        handleFiles(e.dataTransfer.files);
    });

    fileInput.addEventListener('change', () => {
        handleFiles(fileInput.files);
    });

    function handleFiles(files) {
        Array.from(files).forEach(file => {
            console.log('Archivo seleccionado:', file.name);
            // Aquí puedes agregar lógica para mostrar los archivos seleccionados
        });
    }
</script>
</body>
</html>