--1. Mostra os postos de traballo que hai en cada departamento (código de dept e nome do posto de traballo). Non deben aparecer repetidos.
SELECT DISTINCT deptno, job 
FROM emp 
ORDER BY deptno --Opcional
--2. Mostra os códigos de empregados que son xefes. No resultado non deben aparecer filas con nulos.
SELECT mgr -- Los códigos que están en MGR son jefe de
FROM emp
WHERE mgr IS NOT NULL 
--3. Mostra as cidades onde se executan proxectos controlados polo departamento 30. Non deben aparecer repetidos no resultado.
SELECT DISTINCT loc 
FROM pro --Donde se ejecutan proyectos
WHERE deptno = 30
--4. Mostra empregados que non teñen xefe.
SELECT ename, empno
FROM emp 
WHERE mgr IS NULL 
--5. Mostra empregados que teñan xefe e que gañen (incluíndo salario e comisión) máis de 2500.
SELECT empno, ename
FROM emp 
WHERE mgr IS NOT NULL AND ( sal > 2500 OR sal+comm > 2500) --comm tiene algunas filas vacías por lo que hay que contemplar sal a parte.
--6. Mostra os empregados cuxo nome comeza por ‘S’.
SELECT empno, ename 
FROM emp 
WHERE ename LIKE 'S%'--Si solo ponemos el porcentaje al final es s + algo, si lo ponemos al principio tmb salen los nombres con s intercaladas.
--7. Mostra os empregados que gañan (incluíndo salario e comisión) entre 1500 e 2500 euros.
SELECT empno, ename
FROM emp 
WHERE (sal BETWEEN 1500 AND 2500 AND comm IS NULL) OR (sal+comm between 1500 and 2500)
--8. Mostra os empregados que son ‘CLERK’, ‘SALESMAN’ ou ‘ANALYST’ e gañan (incluíndo salario e comisión) máis de 1250.
SELECT empno, ename, sal, comm, job
FROM emp 
WHERE job IN ('CLERK','SALESMAN','ANALYST') AND ( sal>1250 OR sal+comm > 1250 )



--1. Muestra cuantos empleados hay y a cuanto ascienden sus ingresos (sumando los de todos e incluyendo salario y comisión) que sean SALESMAN o CLERK.
SELECT count(*), sum(sal + COALESCE(comm, 0)) --COALESCE porque puede ser nula la comisión
FROM emp 
WHERE job IN ('CLERK','SALESMAN')
--2. Cuantos empleados tienen comisión, cuantos no tienen comisión, a cuanto asciende el salario medio, y a cuanto asciende la comisión media.
SELECT count(comm), count(*)-count(comm),avg(sal), avg(comm)
FROM emp 
--3. Empleados con un nombre de más de 5 letras.
SELECT ename 
FROM emp 
WHERE ename LIKE '______'
--Hacen lo mismo
SELECT ename
FROM emp
WHERE length(ename)>5
--4. Cuantos empleados trabajan para los departamentos 20 y 30, y cuantos trabajos distintos se desempeñan en esos departamentos.
SELECT count(*), count( DISTINCT job)
FROM emp 
WHERE deptno IN (20,30)
--5. Cuantos empleados tienen jefe, cuantos son jefes u cuantos no son jefes.
SELECT count(mgr), count(DISTINCT mgr), count(empno)-count(DISTINCT mgr)
FROM emp 
--6. Cuantos son los ingresos (salario más comisión) medios deslo empleados contratados después del 01-08-1981.
SELECT avg(COALESCE(sal+comm,sal))
FROM emp 
WHERE hiredate > TO_DATE('01-08-1981', 'DD-MM-YYYY')


--1. Cuantos empleados hay en cada departamento, cuantos tienen comisión, cuantos no tienen comisión y cuales son los ingresos medios (incluyendo salario y comisión).
SELECT deptno, count(*), count(comm), count(*) - count(comm), avg(COALESCE(sal+comm,sal))
FROM emp 
GROUP BY deptno
--2. Muestra los departamentos que tienen empleados con comisión. No puede haber valores repetidos.
SELECT DISTINCT deptno --Solo te pide que enseñes que departamento tiene gente con comisión
FROM emp
WHERE comm IS NOT NULL
--3. Para cada departamento muestra la comisión media; si no tiene empleados con comisión, se debe indicar indicar cun 0.
SELECT DISTINCT deptno, coalesce(avg(comm),0)
FROM emp 
GROUP BY deptno
--4. Para cada departamento muestra cuantos puestos de trabajo distintos desempeñan sus trabajadores.
SELECT deptno, count(DISTINCT job)
FROM emp 
GROUP BY deptno 
--5. Para cada departamento muestra cuantos empleados hay de cada puesto de trabajo.
SELECT deptno, job, count(*) --count(job)
FROM emp 
GROUP BY deptno, job
--6. Muestra cuantos empleados tienen unos ingresos superiores a 2500 € en cada departamento.
SELECT deptno, count(*)
FROM emp 
WHERE coalesce(sal + comm, sal) > 2500
GROUP BY deptno 


--2. Muestra los departamentos con unos ingresos medios superiores a 2500 €. Muestra para cada uno, cuantos empleados tienen.
SELECT deptno, count(*)
FROM emp 
GROUP BY deptno 
HAVING avg(COALESCE(sal+comm,sal)) > 2500
--3. Departamentos con, por lo menos, dos ‘MANAGER’
SELECT deptno, count(*)
FROM emp 
WHERE job LIKE 'MANAGER'
GROUP BY deptno 
HAVING count(*) >= 2
--4. Departamentos con, por lo menos, dos empleados con comisión. Para cada departamento muestra cuántos empleados tiene (en total) y cuántos con comisión.
SELECT deptno, count(*), count(comm)
FROM emp 
GROUP BY deptno 
HAVING count(comm) >= 2 
--5. Departamentos con, por lo menos, dos empleados con el mismo puesto de trabajo. No pueden aparecer repetidos.
SELECT DISTINCT deptno
FROM emp
GROUP BY deptno,job
HAVING count(*)>=2


--1. Para cada proyecto muestra su nombre y el nombre del departamento que los controla.
SELECT pname, dname
FROM pro p JOIN dept d ON p.deptno=d.deptno
--2. Para cada empleado muestra su nombre y los códigos de proyectos para los que trabaja.
SELECT ename, prono
FROM emp e JOIN emppro ep ON e.empno = ep.empno 
--3. Para cada empleado muestra su nombre y los códigos de proyectos para los que trabaja. Si hay empleados que no trabajan en proyectos, estes deben aparecer
--con el código de proyecto a nulo.
SELECT ename, prono
FROM emp e LEFT JOIN emppro ep ON e.empno = ep.empno 
--4. Para cada empleado muestra el nombre de su jefe; si no tiene jefe, muestra un nulo en el nombre del jefe.
SELECT e.ename, j.ename
FROM emp e LEFT JOIN emp j ON e.empno=j.mgr 
--5. Para cada empleado muestra su nombre, el nombre de su jefe y el departamento para el que trabaja su jefe.
SELECT e.ename, j.ename, d.dname
FROM emp e JOIN emp j ON e.mgr=j.empno JOIN dept d ON j.deptno=d.deptno
--6. Devuelve los empleados que tienen un salario más alto que su jefe.
SELECT e.ename, e.sal, j.ename, j.sal
FROM emp e JOIN emp j ON e.mgr=j.empno
WHERE e.sal>j.sal


--1. Para cada empleado muestra su nombre y cuantas horas trabajó en proyectos.
SELECT ename, sum(hours)
FROM emp e JOIN emppro j ON e.empno = j.empno 
GROUP BY e.empno, ename
--2. Para cada departamento, muestra su nombre y cuantos empleados tiene.
SELECT d.deptno, dname, count(ename)
FROM dept d JOIN emp e ON d.deptno = e.deptno
GROUP BY d.deptno, dname
--3. Para cada jefe, muestra su nombre y cuantos subordinados tiene.
SELECT j.ename, count(e.empno)
FROM emp e JOIN emp j ON e.mgr=j.empno
GROUP BY j.empno, j.ename
--4. Muestra el nombre de lo proyectos donde se trabajó (en total, todos los empleados) más de 15 horas.
SELECT pname, sum(hours)
FROM pro p JOIN emppro ep ON p.prono = ep.prono
GROUP BY p.prono, pname
HAVING sum(hours) > 15
--5. Muestra los departamentos (nombre) que controlan más de dos proyectos.
SELECT dname, count(prono)
FROM dept d JOIN pro p ON d.deptno = p.deptno 
GROUP BY d.deptno, dname
HAVING count(*) > 2
--6. Muestra los departamentos (nombre) donde hay por lo menos dos empleados con el mismo puesto de trabajo. No deben aparecer repetidos.
SELECT DISTINCT dname
FROM emp e JOIN dept d ON e.deptno=d.deptno
GROUP BY d.deptno, dname, job
HAVING count(*)>=2
--7. Para cada departamento muestra su nombre y cuantos empleados tiene; si no tiene ninguno, hay que indicarlo con un 0.
SELECT dname, count(COALESCE(empno,0))
FROM dept d RIGHT JOIN emp e ON d.deptno = e.deptno 
GROUP BY d.deptno, dname
--8. Para cada empleado muestra las horas que trabajó en proyectos; si no trabajó en ninguno, hay que indicarlo con un 0.
SELECT ename, COALESCE(sum(hours),0)
FROM emp e LEFT JOIN emppro ep ON e.empno=ep.empno
GROUP BY e.empno, ename
--9. Para cada jefe, cuantos subordinados ganan más que él; si no lo gana ninguno, hay que indicarlo con un 0.
SELECT j.ename, count(e.ename)
FROM emp e RIGHT JOIN emp j ON e.mgr = j.empno 
AND e.sal>j.sal
GROUP BY j.empno, j.ename


--1. Empleados que tienen un salario mayor al salario medio de la empresa.
SELECT empno, ename, sal
FROM emp
WHERE sal > (SELECT avg(sal) FROM emp)
--2. Para cada departamento, muestra cuantos empleados tienen que ganan más del salario medio de la empresa. Muestra el nombre del departamento.
SELECT dname, count(*)
FROM emp e JOIN dept d ON e.deptno=d.deptno
WHERE sal > (SELECT avg(sal) FROM emp)
GROUP BY d.deptno, dname
--3. Empleados que son jefe. Muestra su nombre.
SELECT DISTINCT j.ename
FROM emp e JOIN emp j ON e.mgr = j.empno
-- Solución pdf abajo, mi solución arriba
SELECT ename
FROM emp
WHERE empno IN (SELECT mgr FROM emp)
--4. Empleados que no son jefes. Muestra su nombre.
SELECT ename
FROM emp
WHERE empno NOT IN (SELECT mgr FROM emp
					WHERE mgr IS NOT NULL)
--5. Muestra el/los empleado(s) (nombre) con el salario más alto.
SELECT ename
FROM emp
WHERE sal= (SELECT max(sal) FROM emp)
--6. Muestra el departamento (nombre) con la suma de salarios más alta.
SELECT dname, sum(sal)
FROM emp e JOIN dept d ON e.deptno=d.deptno
GROUP BY d.deptno, dname
HAVING sum(sal) >= ALL (SELECT sum(sal) FROM emp 
							GROUP BY deptno)
--7. Para los departamentos que tienen empleados con comisión, muestra cuántos empleados tienen comisión, y cuantos no. Muestra el nombre del departamento.
SELECT dname, count(comm), count(*) - count(comm)
FROM dept d JOIN emp e ON d.deptno = e.deptno
WHERE d.deptno IN (SELECT deptno FROM emp 
					WHERE comm IS NOT NULL)
GROUP BY d.deptno, dname


--1. Muestra el/los empleado(s) con el salario más alto de cada departamento.
SELECT ename, deptno, sal
FROM emp e 
WHERE sal = (SELECT max(sal) FROM emp 
				WHERE deptno = e.deptno)
--2. Muestra el código de el/los empleado(s) que más horas trabaja(n) en cada proxecto.
SELECT prono, empno, hours 
FROM emppro ep
WHERE hours = (SELECT max(hours) FROM emppro
				WHERE prono = ep.prono)
--3. Muestra el nombre de el/los empleado(s) que más horas trabaja(n) en cada proxecto.
SELECT prono, ename, hours
FROM emppro ep JOIN emp e ON e.empno=ep.empno
WHERE hours= (SELECT max(hours) FROM emppro
				WHERE prono=ep.prono)
--4. Muestra el nombre de el/los empleado(s) que más horas trabaja(n) en cada proyecto. Muestra también el nombre del proyecto.
SELECT pname, ename, hours
FROM emppro ep JOIN emp e ON e.empno = ep.empno
JOIN pro p ON ep.prono = p.prono
WHERE hours = (SELECT max(hours) FROM emppro
				WHERE prono=ep.prono)
--5. Para cada departamento muestra su nombre y cuantos empleados de ese departamento tienen un salario mayor al salario medio de su departamento.
SELECT dname, count(*)
FROM emp e JOIN dept d ON e.deptno = d.deptno
WHERE sal > (SELECT avg(sal) FROM emp
				WHERE deptno = d.deptno)
GROUP BY d.deptno, dname
--6. Para cada departamento muestra su nombre y cuantos empleados ganan más que su jefe.
SELECT dname, count(*)
FROM emp e JOIN dept d ON e.deptno = d.deptno
WHERE sal > (SELECT sal FROM emp
				WHERE empno = e.mgr)
GROUP BY d.deptno, dname
