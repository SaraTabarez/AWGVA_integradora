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

    public String getRutaArchivo() { return rutaArchivo; }
    public void setRutaArchivo(String rutaArchivo) { this.rutaArchivo = rutaArchivo; }

    public String getNombreArchivo() { return nombreArchivo; }
    public void setNombreArchivo(String nombreArchivo) { this.nombreArchivo = nombreArchivo; }

    public Long getTamanoArchivo() { return tamanoArchivo; }
    public void setTamanoArchivo(Long tamanoArchivo) { this.tamanoArchivo = tamanoArchivo; }

    public LocalDateTime getSubidoEn() { return subidoEn; }
    public void setSubidoEn(LocalDateTime subidoEn) { this.subidoEn = subidoEn; }
}