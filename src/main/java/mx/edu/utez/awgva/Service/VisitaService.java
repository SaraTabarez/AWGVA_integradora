package mx.edu.utez.awgva.Service;

import mx.edu.utez.awgva.Dao.VisitaDao;
import mx.edu.utez.awgva.Model.Empresa;
import mx.edu.utez.awgva.Model.GrupoVisita;
import mx.edu.utez.awgva.Model.Visita;

import java.util.List;

public class VisitaService {

    private VisitaDao visitaDao;

    public VisitaService() {
        this.visitaDao = new VisitaDao();
    }

    public boolean crearVisitaCompleta(Visita visita, Empresa empresa, GrupoVisita grupoVisita) {
        return visitaDao.guardarVisitaCompleta(visita, empresa, grupoVisita);
    }

    public List<Visita> obtenerVisitasPorUsuario(Long idUsuario) {
        return visitaDao.obtenerVisitasPorUsuario(idUsuario);
    }
}