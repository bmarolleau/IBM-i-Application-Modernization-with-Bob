import { Button, Select, SelectItem, TableToolbar, TableToolbarContent, TableToolbarSearch } from "@carbon/react";

interface ArticleListToolbarProps {
  search: string;
  setSearch: (search: string) => void;
  onCreateClick: () => void;
  familyFilter: string;
  setFamilyFilter: (filter: string) => void;
  sortField: "id" | "descripcion" | "codigoFamilia" | "precioVenta" | "stock";
  setSortField: (field: "id" | "descripcion" | "codigoFamilia" | "precioVenta" | "stock") => void;
  sortDirection: "asc" | "desc";
  setSortDirection: (direction: "asc" | "desc") => void;
  familyOptions: string[];
}

export default function ArticleListToolbar({
  search,
  setSearch,
  onCreateClick,
  familyFilter,
  setFamilyFilter,
  sortField,
  setSortField,
  sortDirection,
  setSortDirection,
  familyOptions
}: ArticleListToolbarProps) {
  return (
    <TableToolbar>
      <TableToolbarContent>
        <Button kind="primary" size="sm" onClick={onCreateClick}>
          Crear articulo
        </Button>
        <TableToolbarSearch
          persistent
          value={search}
          onChange={(event) => {
            setSearch(event.target.value);
          }}
        />
        <Select
          id="family-filter"
          size="sm"
          labelText="Familia"
          value={familyFilter}
          onChange={(event) => {
            setFamilyFilter(event.target.value);
          }}
        >
          <SelectItem value="ALL" text="Todas" />
          {familyOptions.map((option) => (
            <SelectItem key={option} value={option} text={option} />
          ))}
        </Select>
        <Select
          id="sort-field"
          size="sm"
          labelText="Ordenar por"
          value={sortField}
          onChange={(event) => {
            setSortField(
              event.target.value as
                | "id"
                | "descripcion"
                | "codigoFamilia"
                | "precioVenta"
                | "stock"
            );
          }}
        >
          <SelectItem value="id" text="ID" />
          <SelectItem value="descripcion" text="Descripcion" />
          <SelectItem value="codigoFamilia" text="Familia" />
          <SelectItem value="precioVenta" text="Precio" />
          <SelectItem value="stock" text="Stock" />
        </Select>
        <Select
          id="sort-direction"
          size="sm"
          labelText="Direccion"
          value={sortDirection}
          onChange={(event) => {
            setSortDirection(event.target.value as "asc" | "desc");
          }}
        >
          <SelectItem value="asc" text="Ascendente" />
          <SelectItem value="desc" text="Descendente" />
        </Select>
      </TableToolbarContent>
    </TableToolbar>
  );
}
