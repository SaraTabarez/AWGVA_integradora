<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reporte Rechazado</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f9; text-align: center; padding-top: 50px; }
        .card { background: white; width: 500px; margin: auto; padding: 40px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .icon { font-size: 60px; color: #c62828; }
        h1 { color: #c62828; margin-top: 10px; }
        .btn { display: inline-block; margin-top: 20px; padding: 10px 20px; background: #f29927; color: white; text-decoration: none; border-radius: 4px; font-weight: bold; }
    </style>
</head>
<body>

<div class="card">
    <div class="icon">✕</div>
    <h1>Reporte Rechazado</h1>
    <p style="margin-top:15px; color:#555;"><strong>Motivo:</strong> ${sessionScope.observacionesEstadias}</p>
    <a href="${pageContext.request.contextPath}/views/reportes/corregir-reporte.jsp" class="btn">Ir a Corregir Reporte</a>
</div>

</body>
</html>