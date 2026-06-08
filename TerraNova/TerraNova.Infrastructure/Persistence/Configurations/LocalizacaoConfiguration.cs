using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using TerraNova.Domain.Entities;

namespace TerraNova.Infrastructure.Persistence.Configurations;

public sealed class LocalizacaoConfiguration : IEntityTypeConfiguration<Localizacao>
{
    public void Configure(EntityTypeBuilder<Localizacao> builder)
    {
        builder.ToTable("localizacao");
        builder.HasKey(l => l.Id);
        builder.Property(l => l.Id).HasColumnName("id_localizacao");

        // PostGIS: o Npgsql + NetTopologySuite infere automaticamente a coluna
        // `geometry(Point, 4326)` a partir do tipo NetTopologySuite.Geometries.Point
        // e injeta as views de metadados (geometry_columns) sem nenhum SQL manual.
        // Por isso NÃO definimos HasColumnType("SDO_GEOMETRY") aqui.
        builder.Property(l => l.Coordenadas)
            .HasColumnName("coordenadas")
            .IsRequired();
    }
}
