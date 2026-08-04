package mx.edu.utez.awgva.Model;

import java.time.LocalDateTime;

public class Documento {
    private Long idDocumento;
    private Long idVisitaFk;
    private String tipoDocumento;
    private String rutaArchivo;
    private String nombreArchivo;
    private Long tamanoArchivo;
    private LocalDateTime subidoEn;
    private String estado;
    private String observaciones;
    private Long idRevisorFk;
    private LocalDateTime revisadoEn;

    // Datos de autorización; no forman parte de la tabla DOCUMENTO.
    private Long idPropietario;
    private Long idDivision;

    // Constructor vacío
    public Documento() {}

    // Constructor completo
    public Documento(Long idVisitaFk, String tipoDocumento, String rutaArchivo,
                     String nombreArchivo, Long tamanoArchivo) {
        this.idVisitaFk = idVisitaFk;
        this.tipoDocumento = tipoDocumento;
        this.rutaArchivo = rutaArchivo;
        this.nombreArchivo = nombreArchivo;
        this.tamanoArchivo = tamanoArchivo;
    }

    // Getters y Setters
    public Long getIdDocumento() { return idDocumento; }
    public void setIdDocumento(Long idDocumento) { this.idDocumento = idDocumento; }

    public Long getIdVisitaFk() { return idVisitaFk; }
    public void setIdVisitaFk(Long idVisitaFk) { this.idVisitaFk = idVisitaFk; }

    public String getTipoDocumento() { return tipoDocumento; }
    public void setTipoDocumento(String tipoDocumento) { this.tipoDocumento = tipoDocumento; }
    public String getTipoLegible() {
        if ("SOLICITUD_VISITA".equalsIgnoreCase(tipoDocumento)) return "Solicitud de visita";
        if ("CARTA_RESPONSIVA".equalsIgnoreCase(tipoDocumento)) return "Carta responsiva";
        if ("REPORTE".equalsIgnoreCase(tipoDocumento)) return "Reporte";
        return tipoDocumento;
    }

    public String getRutaArchivo() { return rutaArchivo; }
    public void setRutaArchivo(String rutaArchivo) { this.rutaArchivo = rutaArchivo; }

    public String getNombreArchivo() { return nombreArchivo; }
    public void setNombreArchivo(String nombreArchivo) { this.nombreArchivo = nombreArchivo; }

    public Long getTamanoArchivo() { return tamanoArchivo; }
    public void setTamanoArchivo(Long tamanoArchivo) { this.tamanoArchivo = tamanoArchivo; }

    public LocalDateTime getSubidoEn() { return subidoEn; }
    public void setSubidoEn(LocalDateTime subidoEn) { this.subidoEn = subidoEn; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }

    public Long getIdRevisorFk() { return idRevisorFk; }
    public void setIdRevisorFk(Long idRevisorFk) { this.idRevisorFk = idRevisorFk; }

    public LocalDateTime getRevisadoEn() { return revisadoEn; }
    public void setRevisadoEn(LocalDateTime revisadoEn) { this.revisadoEn = revisadoEn; }

    public Long getIdPropietario() { return idPropietario; }
    public void setIdPropietario(Long idPropietario) { this.idPropietario = idPropietario; }

    public Long getIdDivision() { return idDivision; }
    public void setIdDivision(Long idDivision) { this.idDivision = idDivision; }
}