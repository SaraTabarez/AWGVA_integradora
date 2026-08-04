<%--
  Created by IntelliJ IDEA.
  User: pc
  Date: 04/08/2026
  Time: 08:32 a. m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Histórico de Dirección - AWGVA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/portal.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/Layout/sidebar.jsp"/>

<main class="portal-main">
    <header class="page-top">
        <div>
            <div class="eyebrow">Director - sólo lectura</div>
            <h1 class="page-title">Histórico de <c:out value="${sessionScope.usuario.nombreDivision}"/></h1>
            <p class="page-subtitle">Selecciona una carrera de tu división. Los registros históricos no se pueden editar.</p>
        </div>
    </header>

    <form class="panel toolbar" method="get" action="${ctx}/director/historico">
        <div class="grow">
            <label class="form-label">Buscar</label>
            <input class="form-control" name="q" value="<c:out value='${param.q}'/>" placeholder="ID, empresa o lugar">
        </div>
        <div class="grow">
            <label class="form-label">Carrera</label>
            <select class="form-select" name="carrera">
                <option value="">Todas las carreras</option>
                <c:forEach var="carrera" items="${carreras}">
                    <option value="<c:out value='${carrera}'/>" ${carreraSeleccionada == carrera ? 'selected' : ''}>
                        <c:out value="${carrera}"/>
                    </option>
                </c:forEach>
            </select>
        </div>
        <button class="btn-orange" type="submit">Aplicar filtros</button>
    </form>

    <section class="panel">
        <c:choose>
            <c:when test="${empty solicitudes}">
                <div class="empty">
                    <i class="bi bi-clock-history"></i>No hay solicitudes completadas para la carrera seleccionada.
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-wrap">
                    <table class="portal-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Empresa</th>
                            <th>Fecha</th>
                            <th>Carrera</th>
                            <th>Grupo</th>
                            <th>Acción</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${solicitudes}">
                            <tr>
                                <td>#<c:out value="${item.idVisita}"/></td>
                                <td><c:out value="${item.empresa}"/></td>
                                <td><c:out value="${item.fechaInicio}"/></td>
                                <td><c:out value="${item.carrera}"/></td>
                                <td><c:out value="${item.grupo}"/></td>
                                <td>
                                    <a class="btn-navy" href="${ctx}/director/solicitud?id=${item.idVisita}&origen=historico">
                                        <i class="bi bi-eye"></i> Ver
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>
</body>
</html>