<%--
  Created by IntelliJ IDEA.
  User: pc
  Date: 04/08/2026
  Time: 08:23 a. m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Cambiar contraseña - AWGVA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/portal.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/Layout/sidebar.jsp"/>

<main class="portal-main">
    <header class="page-top">
        <div>
            <div class="eyebrow">Cuenta</div>
            <h1 class="page-title">Cambiar contraseña</h1>
            <p class="page-subtitle">Actualiza de forma segura la contraseña de tu cuenta.</p>
        </div>
    </header>

    <section class="panel" style="max-width:680px">
        <c:if test="${not empty error}">
            <div class="alert-error-soft">
                <c:out value="${error}"/>
            </div>
        </c:if>

        <c:if test="${not empty mensaje}">
            <div class="alert-success-soft">
                <c:out value="${mensaje}"/>
            </div>
        </c:if>

        <form method="post" action="${ctx}/cambiar-contrasena">
            <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">

            <div class="mb-3">
                <label class="form-label">Contraseña actual</label>
                <input class="form-control" type="password" name="passwordActual" required autocomplete="current-password">
            </div>

            <div class="mb-3">
                <label class="form-label">Nueva contraseña</label>
                <input class="form-control" type="password" name="nuevaPassword" required minlength="10" autocomplete="new-password">
                <small class="text-muted">Mínimo 10 caracteres, mayúscula, minúscula, número y símbolo.</small>
            </div>

            <div class="mb-4">
                <label class="form-label">Confirmar nueva contraseña</label>
                <input class="form-control" type="password" name="confirmacion" required minlength="10" autocomplete="new-password">
            </div>

            <button class="btn-orange" type="submit">
                <i class="bi bi-shield-lock"></i> Actualizar contraseña
            </button>
        </form>
    </section>
</main>
</body>
</html>
