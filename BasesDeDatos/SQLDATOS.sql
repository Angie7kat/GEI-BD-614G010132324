--1. Para cada empleado muestra su nombre y cuántas horas trabajó en proyectos.
SELECT ename, sum(hours)
FROM emppro ep JOIN emp e ON ep.empno = e.empno 
GROUP BY ep.empno, ename;
--2. Para cada empleado muestra su nombre, el nombre de su jefe, y el departamento para el que trabaja su jefe.
SELECT e.ename, j.ename, d.dname
FROM emp e JOIN emp j ON e.mgr=j.empno
JOIN dept d ON j.deptno=d.deptno;
--3. Para cada jefe, muestra su nombre y cuántos subordinados tiene.
SELECT j.ename, count(e.empno)
FROM emp e JOIN emp j ON e.mgr=j.empno
GROUP BY j.empno, j.ename;
--4. Muestra el nombre de proyectos donde se ha trabajado (en total, todos los empleados) más de 15 horas
SELECT pname, sum(hours)
FROM pro p JOIN emppro ep ON p.prono = ep.prono
GROUP BY p.prono, pname
HAVING sum(hours) > 15;
--5. Muestra los departamentos (nombre) donde hay por lo menos dos empleados con el mismo puesto de trabajo. No debe aparecer repetidos.
SELECT DISTINCT dname
FROM emp e JOIN dept d ON e.deptno=d.deptno
GROUP BY d.deptno, dname, job
HAVING count(*)>=2;
--6. Para cada proyecto muestra el empleado que ha trabajado más horas. Muestra los nombres del proyecto y empleado
SELECT pname, ename, hours
FROM pro p JOIN emppro ep ON p.prono = ep.prono
JOIN emp e ON e.empno = ep.empno
WHERE hours >= ALL (SELECT hours FROM emppro
                    WHERE prono=p.prono);
--7. Muestra el jefe tal que la suma de los salarios de sus subordinados es la más alta. Muestra su nombre y la suma de salarios de sus subordinados.
SELECT j.ename, sum(e.sal)
FROM emp e JOIN emp j ON e.mgr = j.empno
GROUP BY j.empno, j.ename 
HAVING sum(e.sal) >= ALL (SELECT sum(sal) FROM emp
							WHERE mgr IS NOT NULL
							GROUP BY mgr);
--8. Muestra para cada departamento el proyecto controlado por él donde se han trabajado más horas.
SELECT deptno, pname, sum(hours)
FROM pro p JOIN emppro ep ON p.prono = ep.prono 
GROUP BY p.prono,pname, p.deptno
having sum(hours) >= ALL(select sum(hours) from emppro ep1 join pro p1 on ep1.prono=p1.prono
							where p1.deptno=p.deptno
							group by p1.prono);

