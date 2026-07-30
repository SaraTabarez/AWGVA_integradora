<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Solicitud de Visitas Académicas</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { display: flex; height: 100vh; background-color: #92a0b1; }
        .sidebar { width: 240px; background-color: #1f3752; color: white; display: flex; flex-direction: column; padding-top: 50px; position: fixed; height: 100%; }
        .user-profile { text-align: center; margin-bottom: 50px; }
        .user-icon { width: 90px; height: 90px; background-color: #cccccc; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px auto; }
        .user-icon svg { width: 55px; height: 55px; fill: #111111; }
        .user-profile h3 { font-size: 16px; letter-spacing: 1px; font-weight: 800; color: #ffffff; }
        .menu { list-style: none; flex-grow: 1; }
        .menu li { padding: 18px 30px; cursor: pointer; font-size: 16px; display: flex; align-items: center; gap: 15px; font-weight: 400; }
        .menu li.active { font-weight: 700; }
        .menu li:hover { background-color: #2a4365; }
        .menu li svg { width: 20px; height: 20px; fill: #ffffff; }
        .logout { padding: 20px 30px; cursor: pointer; font-size: 14px; display: flex; align-items: center; gap: 15px; }
        .logout svg { width: 20px; height: 20px; fill: #ffffff; }
        .main-container { margin-left: 240px; flex-grow: 1; padding: 20px; overflow-y: auto; }
        .form-wrapper { background-color: white; padding: 40px; border-radius: 4px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); max-width: 1000px; margin: 0 auto; }
        .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #e2e8f0; padding-bottom: 15px; margin-bottom: 25px; }
        .header h1 { font-size: 22px; color: #000; }
        .logo { font-weight: bold; color: #0d9488; font-size: 24px; font-style: italic; }
        h2 { font-size: 16px; color: #1e293b; margin-bottom: 15px; margin-top: 25px; display: flex; align-items: center; gap: 8px; }
        .form-row { display: flex; gap: 20px; margin-bottom: 15px; }
        .form-group { flex: 1; display: flex; flex-direction: column; }
        label { font-size: 13px; font-weight: 600; margin-bottom: 5px; color: #0f172a; }
        input[type="text"], input[type="email"], input[type="number"], input[type="date"], input[type="time"], select, textarea {
            padding: 10px; border: 1px solid #cbd5e1; border-radius: 4px; font-size: 14px; outline: none; width: 100%;
        }
        textarea { resize: vertical; min-height: 80px; }
        .division-grid { display: grid; grid-template-columns: repeat(5, 1fr); gap: 10px; }
        .division-grid .form-group { text-align: center; }
        .division-grid label { border: 1px solid #cbd5e1; border-bottom: none; padding: 5px; margin: 0; background-color: #f8fafc; }
        .division-grid input { border-radius: 0; text-align: center; }
        .table-section { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        .table-section th { border: 1px solid #cbd5e1; padding: 8px; font-size: 13px; font-weight: normal; }
        .table-section td { border: 1px solid #cbd5e1; padding: 0; }
        .table-section input { border: none; border-radius: 0; width: 100%; height: 35px; }
        .buttons { display: flex; justify-content: space-between; margin-top: 40px; }
        .btn { background-color: #f59e0b; color: white; border: none; padding: 10px 40px; border-radius: 4px; font-weight: bold; cursor: pointer; font-size: 14px; }
        .btn:hover { background-color: #d97706; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="user-profile">
        <div class="user-icon"><svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg></div>
        <h3>DOCENTE</h3>
    </div>
    <ul class="menu">
        <li><svg viewBox="0 0 24 24"><path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/></svg> Inicio</li>
        <li class="active"><svg viewBox="0 0 24 24"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg> Solicitud</li>
        <li><svg viewBox="0 0 24 24"><path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg> Reporte</li>
        <li><svg viewBox="0 0 24 24"><path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67z"/></svg> Histórico</li>
    </ul>
    <div class="logout"><svg viewBox="0 0 24 24"><path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/></svg> Cerrar sesión</div>
</div>

<div class="main-container">
    <div class="form-wrapper">
        <div class="header">
            <h1>SOLICITUD DE VISITAS ACADÉMICAS</h1>
            <div class="logo">⚙️ UTEZ</div>
        </div>

        <!-- FORMULARIO CONECTADO CON EL SERVLET -->
        <form action="solicitud" method="POST">
            <h2>👤 Datos del Solicitante</h2>
            <div class="form-row">
                <div class="form-group">
                    <label>Nombre Completo *</label>
                    <input type="text" name="solicitanteNombre" placeholder="Nombre y Apellido del solicitante" required>
                </div>
                <div class="form-group">
                    <label>Cargo / Rol *</label>
                    <input type="text" name="solicitanteCargo" placeholder="Cargo en la Institución" required>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Teléfono de contacto *</label>
                    <input type="text" name="solicitanteTelefono" placeholder="📞 Teléfono del Solicitante" required>
                </div>
                <div class="form-group">
                    <label>No. de Docentes acompañantes</label>
                    <select name="docentesAcompanantes">
                        <option value="" disabled selected>Máximo 3 acompañantes</option>
                        <option value="0">0</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                    </select>
                </div>
            </div>

            <h2>📖 Datos de la visita</h2>
            <div class="form-row">
                <div class="form-group">
                    <label>Dirección del lugar a visitar *</label>
                    <input type="text" name="empresaDireccion" placeholder="Ubicación del lugar de la visita" required>
                </div>
                <div class="form-group">
                    <label>Nombre de la empresa a visitar *</label>
                    <input type="text" name="empresaNombre" placeholder="Nombre del lugar a visitar" required>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Teléfono de contacto *</label>
                    <input type="text" name="empresaTelefono" placeholder="📞 Teléfono del lugar a visitar" required>
                </div>
                <div class="form-group">
                    <label>Correo electrónico del lugar de la visita *</label>
                    <input type="email" name="empresaEmail" placeholder="empresa@com.mx" required>
                </div>
            </div>
            <div class="form-row" style="gap: 10px;">
                <div class="form-group">
                    <label>Fecha de inicio *</label>
                    <input type="date" name="fechaInicio" required>
                </div>
                <div class="form-group">
                    <label>Fecha de término *</label>
                    <input type="date" name="fechaTermino" required>
                </div>
                <div class="form-group">
                    <label>Hora inicio *</label>
                    <input type="time" name="horaInicio" required>
                </div>
            </div>
            <div class="form-group" style="margin-bottom: 20px;">
                <label>Objetivo de la visita *</label>
                <textarea name="objetivo" placeholder="Describir detalladamente el objetivo para la visita" required></textarea>
            </div>

            <div class="form-group" style="margin-bottom: 30px;">
                <label>No. de estudiantes participantes por división académica: *</label>
                <div class="division-grid">
                    <div class="form-group"><label>DACEA</label><input type="number" min="0" name="dacea"></div>
                    <div class="form-group"><label>DATEFI</label><input type="number" min="0" name="datefi"></div>
                    <div class="form-group"><label>DATID</label><input type="number" min="0" name="datid"></div>
                    <div class="form-group"><label>DAMI</label><input type="number" min="0" name="dami"></div>
                    <div class="form-group"><label>Total estudiantes</label><input type="number" name="totalEstudiantes"></div>
                </div>
            </div>

            <p style="font-size: 13px; color: #475569; margin-bottom: 10px;">La siguiente información es de llenado exclusivo para visita académica</p>
            <div class="form-group">
                <label>Asignaturas que se reforzarán con la visita</label>
                <textarea name="asignaturas"></textarea>
            </div>

            <div class="buttons">
                <button type="button" class="btn">Atrás</button>
                <!-- EDITADO A "Siguiente" -->
                <button type="submit" class="btn">Siguiente</button>
            </div>
        </form>
    </div>
</div>

</body>
</html>