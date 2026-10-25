
--consulta "Rentabilidad por categoría": uní ventas, productos y categorias, y mostrá el nombre de la categoría, las unidades vendidas y el ingreso total.
-- Filtrá con HAVING por las categorías que superen un umbral de ventas que definas vos 
--(dejalo comentado en el script: "umbral definido en X porque…").


--rentabilidad_por_categoria 
select 
	p.categoria as categoria,
    SUM(v.cantventa) as unidades_vendidas,
    SUM(v.cantventa * p.precio) as ingreso_total
from ventas v
INNER join productos p on v.idproducto = p.idproducto
GROUP by p.idproducto
having SUM(v.cantventa * p.precio) > 50000
ORDER BY ingreso_total desc;

--se elije having mayor a 50.000 por ser, en este caso, un valor tipico de ventas por categoria.
--Esta consulta nos permite conocer que rama de nuestro negocio es mas rentable, reforzarla y mejorar el plan de marketing de aqueyos que no tienen tanto movimiento, o en su defecto dejar de ofrecerlo.
	

--consulta "Clientes sin compras" usando LEFT JOIN o subconsulta, 
--para hallar clientes registrados sin coincidencias en ventas. Manejá los nulos con COALESCE.

--clientes_sin_compras
select
    c.nombrecliente,
    v.idventa
from clientes c
LEFT join ventas v on c.idcliente = v.idcliente;

--en este ejemplo no tenemos clientes cargados sin compras registradas.
--este tipo de consulta resolveria el conocer que clientes han sido cargados en sistema y que no hayan comprado.Para poder evaluar su experiencia y mejorar el servicio.

	
--Top de compras por cliente": uní clientes, ventas y productos, 
--y mostrá el nombre del cliente, el producto que más veces compró y la fecha de su última transacción.


---top_de_compras_por_cliente
select 
	c.nombrecliente as cliente,
	v.idproducto as producto_mas_comprado,
	SUM(cantventa) as cant_comprada,
	MAX (fechaventa) as fecha_ult_compra
from clientes c
inner join ventas v on c.idcliente = v.idcliente 
group by c.idcliente, c.nombrecliente, v.idproducto 
--hasta aca, me trae la tabla que buscamos pero no trae el producto mas comprado del cliente, trae todos los que compro y la fecha de la ultima compra. Necesitamos que se detecte cual fue el mas comprado.
having SUM(v.cantventa)=(
						select MAX (t.total)
						from(
							select SUM(cantventa) as total
							from ventas v2
							where v2.idcliente=c.idcliente
							group by v2.idproducto 
							)t);
--a traves del having obtengo cuantas unidades del producto compro el cliente.creo una subconsulta, con una columna auxiliar t, donde se evalua las unidades para obtener solo el de mayor cantidad comprada.

--Esta consulta nos permite conocer que productos son los mas buscados en el ultimo año, mejorar su disponibilidad, y a partir de conocer las fechas de compras, invitar a los clientes a renovar su stock.


