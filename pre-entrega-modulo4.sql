--consulta "Rentabilidad por categoría": uní ventas, productos y categorias, y mostrá el nombre de la categoría, las unidades vendidas y el ingreso total.
-- Filtrá con HAVING por las categorías que superen un umbral de ventas que definas vos 
--(dejalo comentado en el script: "umbral definido en X porque…").


--rentabilidad_por_categoria 
select 
	c.categoria_id as categoria,
    SUM(v.cantidad) as unidades_vendidas,
    SUM(v.cantidad * p.precio) as ingreso_total
from ventas v
inner join productos p on v.producto_id = p.producto_id 
inner join categorias c on p.id_categoria= c.categoria_id
GROUP by c.categoria_id
having SUM(v.cantidad * p.precio) >= 500
ORDER BY ingreso_total desc;

--se elije having mayor a 500 por ser, en este caso, un valor llamativo de ventas por categoria.
--Esta consulta nos permite conocer que rama de nuestro negocio es mas rentable, reforzarla y mejorar el plan de marketing de aqueyos que no tienen tanto movimiento, o en su defecto dejar de ofrecerlo.
	

--consulta "Clientes sin compras" usando LEFT JOIN o subconsulta, 
--para hallar clientes registrados sin coincidencias en ventas. Manejá los nulos con COALESCE.

select 
	c.nombre,
   		 COALESCE(
       			 (SELECT SUM(v.cantidad) FROM ventas v WHERE v.cliente_id = c.cliente_id),0) AS unidades_compradas
from clientes c;

--en este ejemplo Elena no ha realizado compras, por lo tanto se coloca "0" unidades_compradas.
--este tipo de consulta resolveria el conocer que clientes han sido cargados en sistema y que no hayan comprado.Para poder evaluar su experiencia y mejorar el servicio.

	
--Top de compras por cliente": uní clientes, ventas y productos, 
--y mostrá el nombre del cliente, el producto que más veces compró y la fecha de su última transacción.


---top_de_compras_por_cliente
select 
	c.nombre as cliente,
	p.nombre as producto_mas_comprado,
	SUM(cantidad) as cant_comprada,
	MAX (fecha) as fecha_ult_compra
from clientes c
inner join ventas v on c.cliente_id = v.cliente_id
inner join productos p on v.producto_id = p.producto_id 
group by c.cliente_id, c.nombre, p.nombre 
--hasta aca, me trae la tabla que buscamos pero no trae el producto mas comprado del cliente, trae todos los que compro y la fecha de la ultima compra. Necesitamos que se detecte cual fue el mas comprado.
having SUM(v.cantidad)=(
						select MAX (t.total)
						from(
							select SUM(cantidad) as total
							from ventas v2
							where v2.cliente_id=c.cliente_id
							group by v2.producto_id
							)t);
--a traves del having obtengo cuantas unidades del producto compro el cliente.creo una subconsulta, con una columna auxiliar t, donde se evalua las unidades para obtener solo el de mayor cantidad comprada.

--Esta consulta nos permite conocer que productos son los mas buscados en el ultimo año, mejorar su disponibilidad, y a partir de conocer las fechas de compras, invitar a los clientes a renovar su stock.


