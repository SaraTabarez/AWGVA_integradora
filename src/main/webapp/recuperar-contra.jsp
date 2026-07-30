<%--
  Created by IntelliJ IDEA.
  User: pc
  Date: 27/07/2026
  Time: 06:07 a. m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String step = request.getParameter("step");
    if (step == null || step.isEmpty()) {
        step = "codigo";
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recuperar Contraseña - AWGVA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f5f7;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }
        .recovery-card {
            border: 1px solid #d1d5db;
            border-radius: 12px;
            background-color: #ffffff;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        .btn-orange {
            background-color: #ff7020;
            color: #ffffff;
            border: none;
        }
        .btn-orange:hover {
            background-color: #e05d10;
            color: #ffffff;
        }
        .code-input {
            width: 45px;
            height: 50px;
            text-align: center;
            font-size: 1.25rem;
            font-weight: bold;
            border: 1px solid #ced4da;
            border-radius: 6px;
        }
        .code-input:focus {
            border-color: #ff7020;
            outline: none;
            box-shadow: 0 0 0 0.25rem rgba(255, 112, 32, 0.25);
        }
    </style>
</head>
<body class="d-flex align-items-center justify-content-center py-5">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-12 col-md-8 col-lg-6">
            <% if ("codigo".equals(step)) { %>
            <h3 class="text-center fw-bold text-dark mb-4">Enviar código de seguridad</h3>
            <div class="card recovery-card p-4 p-md-5">
                <p class="text-center fw-semibold text-muted mb-3">Se envió un código al correo:</p>
                <form action="<%= request.getContextPath() %>/reset-password" method="POST">
                    <input type="hidden" name="action" value="verifyCode">
                    <div class="mb-3">
                        <input type="email" class="form-control text-center bg-light border-0 py-2 fw-semibold" value="usuario@utez.edu.mx" readonly>
                    </div>
                    <div class="d-flex justify-content-center gap-2 mb-4">
                        <input type="text" maxlength="1" class="code-input" autofocus>
                        <input type="text" maxlength="1" class="code-input">
                        <input type="text" maxlength="1" class="code-input">
                        <input type="text" maxlength="1" class="code-input">
                        <input type="text" maxlength="1" class="code-input">
                        <input type="text" maxlength="1" class="code-input">
                        <input type="hidden" name="code" id="fullCode">
                    </div>

                    <div class="row g-2">
                        <div class="col-6">
                            <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-orange w-100 py-2 d-flex align-items-center justify-content-center gap-2">
                                <i class="bi bi-box-arrow-in-right"></i> Volver al login
                            </a>
                        </div>
                        <div class="col-6">
                            <button type="submit" class="btn btn-orange w-100 py-2 d-flex align-items-center justify-content-center gap-2">
                                <i class="bi bi-chat-dots"></i> Confirmar código
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <% } else if ("nueva".equals(step)) { %>
            <h3 class="text-center fw-bold text-dark mb-4">Cambiar contraseña</h3>

            <div class="card recovery-card p-4 p-md-5">
                <p class="text-center fw-semibold text-muted mb-4">Modifica tu nueva contraseña</p>

                <form action="<%= request.getContextPath() %>/reset-password" method="POST">
                    <input type="hidden" name="action" value="updatePassword">

                    <div class="mb-3">
                        <div class="input-group">
                            <input type="password" class="form-control bg-light border-0 py-2" name="newPassword" placeholder="Ingresa una nueva contraseña" required>
                            <span class="input-group-text bg-light border-0 text-muted"><i class="bi bi-eye-slash"></i></span>
                        </div>
                    </div>

                    <div class="mb-4">
                        <div class="input-group">
                            <input type="password" class="form-control bg-light border-0 py-2" name="confirmPassword" placeholder="Confirmar contraseña" required>
                            <span class="input-group-text bg-light border-0 text-muted"><i class="bi bi-eye-slash"></i></span>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-orange px-4 py-2 d-flex align-items-center gap-2">
                            <i class="bi bi-box-arrow-in-right"></i> Iniciar sesión
                        </button>
                    </div>
                </form>
            </div>
            <% } %>

        </div>
    </div>
</div>

<script>
    const inputs = document.querySelectorAll('.code-input');
    const fullCodeHidden = document.getElementById('fullCode');

    inputs.forEach((input, index) => {
        input.addEventListener('keyup', (e) => {
            if (e.key >= 0 && e.key <= 9) {
                if (index < inputs.length - 1) inputs[index + 1].focus();
            } else if (e.key === 'Backspace') {
                if (index > 0) inputs[index - 1].focus();
            }
            if(fullCodeHidden) {
                let code = '';
                inputs.forEach(i => code += i.value);
                fullCodeHidden.value = code;
            }
        });
    });
</script>
</body>
</html>