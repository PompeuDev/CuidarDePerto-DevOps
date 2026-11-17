using CuidarDePerto.Api.Data;
using CuidarDePerto.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CuidarDePerto.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AlertaController : ControllerBase
    {
        private readonly CuidarDePertoContext _context;

        public AlertaController(CuidarDePertoContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Alerta>>> GetAlertas()
        {
            return await _context.Alertas.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Alerta>> GetAlerta(int id)
        {
            var alerta = await _context.Alertas.FindAsync(id);
            if (alerta == null) return NotFound();

            return alerta;
        }

        [HttpPost]
        public async Task<ActionResult<Alerta>> PostAlerta(Alerta alerta)
        {
            _context.Alertas.Add(alerta);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetAlerta), new { id = alerta.Id }, alerta);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutAlerta(int id, Alerta alerta)
        {
            if (id != alerta.Id) return BadRequest();

            _context.Entry(alerta).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAlerta(int id)
        {
            var alerta = await _context.Alertas.FindAsync(id);
            if (alerta == null) return NotFound();

            _context.Alertas.Remove(alerta);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
