<%--
  Created by IntelliJ IDEA.
  User: pc
  Date: 27/07/2026
  Time: 06:06 a. m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión - AWGVA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }
        .login-card {
            border: none;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .bg-sidebar {
            background-color: #1e2d42;
            color: #ffffff;
        }
        .brand-orange {
            color: #ff7020;
        }
        .btn-brand-dark {
            background-color: #2b354f;
            color: #ffffff;
            border: none;
        }
        .btn-brand-dark:hover {
            background-color: #1e2738;
            color: #ffffff;
        }
        .form-control:focus {
            border-color: #ff7020;
            box-shadow: 0 0 0 0.25rem rgba(255, 112, 32, 0.25);
        }
        .feature-item {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 0.95rem;
        }
    </style>
</head>
<body class="d-flex align-items-center justify-content-center py-4">

<div class="container my-auto">
    <div class="row justify-content-center">
        <div class="col-12 col-xl-10">
            <div class="card login-card">
                <div class="row g-0">

                    <div class="col-md-5 bg-sidebar p-5 d-flex flex-column justify-content-between">
                        <div>

                            <div class="d-flex align-items-center mb-5">
                                <i class="bi bi-stack text-warning fs-3 me-2"></i>
                                <span class="fw-bold fs-4 tracking-wide">AWGVA</span>
                            </div>

                            <h2 class="fw-bold mb-4">
                                Sistema de Gestión de <br>
                                <span class="brand-orange">Visitas Académicas</span>
                            </h2>

                            <div class="mt-4 d-flex flex-column gap-3 opacity-90">
                                <div class="feature-item">
                                    <i class="bi bi-shield-check brand-orange fs-5"></i>
                                    <span>Acceso seguro.</span>
                                </div>
                                <div class="feature-item">
                                    <i class="bi bi-people brand-orange fs-5"></i>
                                    <span>Gestión de usuarios.</span>
                                </div>
                                <div class="feature-item">
                                    <i class="bi bi-file-earmark-text brand-orange fs-5"></i>
                                    <span>Formatos de visitas académicas.</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-7 bg-white p-5 d-flex flex-column justify-content-center">
                        <div class="px-lg-4">
                            <span class="text-uppercase fw-bold brand-orange small tracking-wider">BIENVENIDO</span>
                            <h2 class="fw-bold text-dark mb-1">Iniciar Sesión</h2>
                            <p class="text-muted mb-4 small">Ingresa tus credenciales.</p>

                            <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger py-2" role="alert">
                                <i class="bi bi-exclamation-circle me-1"></i> <%= request.getAttribute("error") %>
                            </div>
                            <% } %>

                            <form action="<%= request.getContextPath() %>/login" method="POST">
                                <div class="mb-3">
                                    <label class="form-label text-uppercase fw-bold small text-muted">Correo electrónico:</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-envelope"></i></span>
                                        <input type="text" class="form-control bg-light border-start-0" name="usuario" placeholder="usuario@utez.edu.mx" required>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label text-uppercase fw-bold small text-muted">Contraseña:</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-lock"></i></span>
                                        <input type="password" id="passwordInput" class="form-control bg-light border-start-0 border-end-0" name="password" placeholder="••••••••" required>
                                        <button class="btn btn-light border border-start-0 text-muted" type="button" id="togglePassword">
                                            <i class="bi bi-eye-slash" id="toggleIcon"></i>
                                        </button>
                                    </div>
                                </div>

                                <!-- Botón Ingresar -->
                                <button type="submit" class="btn btn-brand-dark w-100 py-2 fw-semibold mb-4">Ingresar</button>

                                <!-- Enlaces inferiores -->
                                <div class="d-flex justify-content-between align-items-center small">
                                    <a href="#" class="text-decoration-none text-muted">Registrar cuenta</a>
                                    <a href="<%= request.getContextPath() %>/recuperar-contra.jsp" class="text-decoration-none text-muted">¿Olvidaste tu contraseña?</a>
                                </div>
                            </form>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const togglePassword = document.querySelector('#togglePassword');
    const password = document.querySelector('#passwordInput');
    const toggleIcon = document.querySelector('#toggleIcon');

    togglePassword.addEventListener('click', function () {
        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
        password.setAttribute('type', type);
        toggleIcon.classList.toggle('bi-eye');
        toggleIcon.classList.toggle('bi-eye-slash');
    });
</script>

</body>
</html>