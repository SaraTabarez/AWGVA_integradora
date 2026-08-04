package mx.edu.utez.awgva.Service;

import mx.edu.utez.awgva.Dao.DocumentoDao;
import mx.edu.utez.awgva.Model.Documento;

import java.util.List;
import java.util.Locale;
import java.util.Set;

public class DocumentoService {
    public static final Set<String> TIPOS_PERMITIDOS = Set.of(
            "SOLICITUD_VISITA", "CARTA_RESPONSIVA", "REPORTE"
    );

    private final DocumentoDao documentoDao = new DocumentoDao();

    public boolean guardar(Documento documento) {
        documento.setTipoDocumento(normalizarTipo(documento.getTipoDocumento()));
        return documentoDao.guardarOReemplazar(documento);
    }

    public List<Documento> listarPorVisita(Long idVisita) {
        return documentoDao.listarPorVisita(idVisita);
    }

    public Documento buscarPorId(Long idDocumento) {
        return documentoDao.buscarPorId(idDocumento);
    }

    public Documento buscarPorVisitaYTipo(Long idVisita, String tipo) {
        return documentoDao.buscarPorVisitaYTipo(idVisita, normalizarTipo(tipo));
    }

    public boolean revisar(Long idDocumento, String decision, String observaciones, Long revisor) {
        String estado = "ACEPTAR".equalsIgnoreCase(decision) ? "ACEPTADO" : "RECHAZADO";
        String detalle = observaciones == null ? null : observaciones.trim();
        if ("RECHAZADO".equals(estado) && (detalle == null || detalle.isBlank())) {
            throw new IllegalArgumentException("Escribe las observaciones del rechazo.");
        }
        return documentoDao.revisar(idDocumento, estado, detalle, revisor);
    }

    public String normalizarTipo(String tipo) {
        String normalizado = tipo == null ? "" : tipo.trim().toUpperCase(Locale.ROOT);
        if (!TIPOS_PERMITIDOS.contains(normalizado)) {
            throw new IllegalArgumentException("Tipo de documento no permitido.");
        }
        return normalizado;
    }
}
