using CuidarDePerto.Api.Data;
using Microsoft.EntityFrameworkCore;

namespace CuidarDePerto.Api
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Adicionar o DbContext do Entity Framework Core com Oracle.
            // A string de conexão vem de "ConnectionStrings:OracleConnection" e, no container,
            // é sobrescrita pela variável de ambiente ConnectionStrings__OracleConnection (docker-compose.yml).
            builder.Services.AddDbContext<CuidarDePertoContext>(options =>
                options.UseOracle(builder.Configuration.GetConnectionString("OracleConnection")));

            // Add services to the container.
            builder.Services.AddControllers();
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            var app = builder.Build();

            // Swagger habilitado em todos os ambientes: é ele que demonstra o CRUD na VM Azure.
            app.UseSwagger();
            app.UseSwaggerUI();

            // No container existe apenas HTTP (porta 8080); o redirecionamento HTTPS só vale no desenvolvimento local.
            if (app.Environment.IsDevelopment())
            {
                app.UseHttpsRedirection();
            }

            app.UseAuthorization();

            app.MapControllers();

            // Atalho: a raiz do site abre o Swagger.
            app.MapGet("/", () => Results.Redirect("/swagger")).ExcludeFromDescription();

            app.Run();
        }
    }
}
