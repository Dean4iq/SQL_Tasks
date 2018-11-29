-- 1
SELECT COUNT(*) AS 'SUM' 
FROM 
	(SELECT * FROM news
		UNION
	SELECT * FROM reviews)
AS searched;

-- 2
SELECT nc_name, COUNT(n_id) as "COUNT('n_id')" 
FROM news
right join news_categories on nc_id=n_category
GROUP BY nc_name;

-- 3
SELECT rc_name, COUNT(r_id) as "COUNT('r_id')" 
FROM reviews
right join reviews_categories on rc_id=r_category
GROUP BY rc_name;

-- 4
SELECT nc_name as category_name, MAX(n_dt) as last_date
FROM news
INNER JOIN news_categories ON nc_id=n_category
GROUP BY nc_name
UNION
SELECT rc_name as category_name, MAX(r_dt) as last_date
FROM reviews
INNER JOIN reviews_categories ON rc_id=r_category
GROUP BY rc_name;

-- 5
SELECT p_name, banners.b_id, b_url
FROM pages, banners, m2m_banners_pages
WHERE p_parent IS null 
AND pages.p_id=m2m_banners_pages.p_id 
AND banners.b_id = m2m_banners_pages.b_id;

-- 6
SELECT DISTINCT p_name
FROM pages
LEFT JOIN m2m_banners_pages ON m2m_banners_pages.p_id = pages.p_id
WHERE b_id IS NOT null;

-- 7
SELECT DISTINCT p_name
FROM pages
LEFT JOIN m2m_banners_pages ON m2m_banners_pages.p_id = pages.p_id
WHERE b_id IS null;

-- 8
SELECT DISTINCT b.b_id, b.b_url
FROM banners b
LEFT JOIN m2m_banners_pages m2m ON m2m.b_id = b.b_id
WHERE p_id IS NOT NULL;

-- 9
SELECT DISTINCT b.b_id, b.b_url
FROM banners b
LEFT JOIN m2m_banners_pages m2m ON m2m.b_id = b.b_id
WHERE p_id IS NULL;

-- 10
SELECT b_id, b_url, b_click/b_show*100 as rate
FROM banners
WHERE b_show > 0 AND (b_click/b_show*100) >= 80;

-- 11
SELECT DISTINCT p_name
FROM pages p 
INNER JOIN m2m_banners_pages m2m ON p.p_id = m2m.p_id
INNER JOIN banners ON m2m.b_id = banners.b_id
WHERE banners.b_text IS NOT NULL;

-- 12
SELECT DISTINCT p_name
FROM pages p 
INNER JOIN m2m_banners_pages m2m ON p.p_id = m2m.p_id
INNER JOIN banners ON m2m.b_id = banners.b_id
WHERE banners.b_pic IS NOT NULL;

-- 13
SELECT n_header as header, n_dt as 'date'
FROM news
WHERE n_dt BETWEEN "2011-01-01" AND "2011-12-31"
UNION
SELECT r_header as header, r_dt as 'date'
FROM reviews
WHERE r_dt BETWEEN "2011-01-01" AND "2011-12-31";

-- 14
SELECT nc_name as category
FROM news_categories
WHERE nc_id NOT IN (SELECT n_category FROM news)
UNION
SELECT rc_name as category
FROM reviews_categories
WHERE rc_id NOT IN (SELECT r_category FROM reviews);

-- 15
SELECT n_header as header, n_dt as 'date'
FROM news
INNER JOIN news_categories ON nc_id=n_category
WHERE n_dt BETWEEN "2012-01-01" AND "2012-12-31"
AND nc_name="Логистика";

-- 16
SELECT YEAR(n_dt) as 'year', COUNT(*)
FROM news
GROUP BY YEAR(n_dt);

-- 17
SELECT b.b_url, b.b_id
FROM banners b
INNER JOIN (SELECT b_url, b_id
			FROM banners
            GROUP BY b_url
            HAVING COUNT(*)>1
            ) datatable ON b.b_url=datatable.b_url;
         
-- 18
SELECT p_name, b.b_id, b.b_url
FROM pages p
INNER JOIN m2m_banners_pages m2m ON m2m.p_id=p.p_id
INNER JOIN banners b ON b.b_id = m2m.b_id
WHERE p_parent = (SELECT p_id 
				FROM pages
                WHERE p_name="Юридическим лицам");

-- 19
SELECT b_id, b_url, (b_click/b_show) as rate
FROM banners
WHERE b_pic IS NOT null
ORDER BY rate DESC;

-- 20
SELECT n_header as header, n_dt as 'date'
FROM (SELECT n_header, n_dt FROM news
UNION
SELECT r_header, r_dt FROM reviews) as sometable
ORDER BY n_dt LIMIT 1;

-- 21
SELECT b.b_url, b.b_id
FROM banners b
INNER JOIN (SELECT b_url, b_id
			FROM banners
            GROUP BY b_url
            HAVING COUNT(*)=1) sometable ON b.b_url=sometable.b_url;
            
-- 22
SELECT p.p_name, COUNT(b.b_id) as banners_count
FROM pages p, m2m_banners_pages b
WHERE b.p_id=p.p_id
GROUP BY p.p_name
ORDER BY banners_count DESC;

-- 23
SELECT n_header as header, n_dt as 'date'
FROM news
WHERE n_dt = (SELECT MAX(n_dt) FROM news)
UNION
SELECT r_header as header, r_dt as 'date'
FROM reviews
WHERE r_dt = (SELECT MAX(r_dt) FROM reviews);

-- 24
SELECT b_id, b_url, b_text
FROM banners
WHERE b_url LIKE CONCAT('%', b_text, '%');

-- 25
SELECT p.p_name
FROM pages p
INNER JOIN m2m_banners_pages m2m ON p.p_id=m2m.p_id
INNER JOIN banners b ON m2m.b_id=b.b_id
WHERE b.b_click/b.b_show=(SELECT MAX(b_click/b_show) FROM banners);

-- 26
SELECT AVG(b_click/b_show) AS "AVG('b_click'/'b_show')"
FROM banners
WHERE b_show>0;

-- 27
SELECT AVG(b_click/b_show) AS "AVG('b_click'/'b_show')"
FROM banners
WHERE b_pic IS null;

-- 28
SELECT COUNT(*) AS 'COUNT'
FROM m2m_banners_pages, pages
WHERE m2m_banners_pages.p_id=pages.p_id AND pages.p_parent IS null;

-- 29
SELECT m2m.b_id, b.b_url, COUNT(p_id) AS 'COUNT'
FROM banners b, m2m_banners_pages m2m
WHERE m2m.b_id=b.b_id
GROUP BY m2m.b_id
HAVING COUNT(p_id) = (SELECT COUNT(p_id) 
				FROM m2m_banners_pages
                GROUP BY b_id
                ORDER BY COUNT(p_id) DESC LIMIT 1);

-- 30
SELECT p_name, COUNT(m2m.p_id) AS 'COUNT'
FROM pages p, m2m_banners_pages m2m
WHERE p.p_id = m2m.p_id
GROUP BY p_name
HAVING COUNT(m2m.p_id)= (SELECT COUNT(p_id)
						FROM m2m_banners_pages
                        GROUP BY p_id
                        ORDER BY COUNT(p_id) DESC LIMIT 1);