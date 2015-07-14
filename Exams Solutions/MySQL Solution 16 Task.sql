insert into users (username, fullname)
values ('pesho', 'Peter Pan'),
('gosho', 'Georgi Manchev'),
('minka', 'Minka Dryzdeva'),
('jivka', 'Jivka Goranova'),
('gago', 'Georgi Georgiev'),
('dokata', 'Yordan Malov'),
('glavata', 'Galin Glavomanov'),
('petrohana', 'Peter Petromanov'),
('jubata', 'Jivko Jurandov'),
('dodo', 'Donko Drozev'),
('bobo', 'Bay Boris');

insert into salaries (from_value, to_value)
values (300, 500),
(400, 600),
(550, 700),
(600, 800),
(1000, 1200),
(1300, 1500),
(1500, 2000),
(2000, 3000);


insert into job_ads (title, description, author_id, salary_id)
values ('PHP Developer', NULL, (select id from users where username = 'gosho'), (select id from salaries where from_value = 300)),
('Java Developer', 'looking to hire Junior Java Developer to join a team responsible for the development and maintenance of the payment infrastructure systems', (select id from users where username = 'jivka'), (select id from salaries where from_value = 1000)),
('.NET Developer', 'net developers who are eager to develop highly innovative web and mobile products with latest versions of Microsoft .NET, ASP.NET, Web services, SQL Server and related applications.', (select id from users where username = 'dokata'), (select id from salaries where from_value = 1300)),
('JavaScript Developer', 'Excellent knowledge in JavaScript', (select id from users where username = 'minka'), (select id from salaries where from_value = 1500)),
('C++ Developer', NULL, (select id from users where username = 'bobo'), (select id from salaries where from_value = 2000)),
('Game Developer', NULL, (select id from users where username = 'jubata'), (select id from salaries where from_value = 600)),
('Unity Developer', NULL, (select id from users where username = 'petrohana'), (select id from salaries where from_value = 550));

insert into job_ad_applications(job_ad_id, user_id)
values 
	((select id from job_ads where title = 'C++ Developer'), (select id from users where username = 'gosho')),
	((select id from job_ads where title = 'Game Developer'), (select id from users where username = 'gosho')),
	((select id from job_ads where title = 'Java Developer'), (select id from users where username = 'gosho')),
	((select id from job_ads where title = '.NET Developer'), (select id from users where username = 'minka')),
	((select id from job_ads where title = 'JavaScript Developer'), (select id from users where username = 'minka')),
	((select id from job_ads where title = 'Unity Developer'), (select id from users where username = 'petrohana')),
	((select id from job_ads where title = '.NET Developer'), (select id from users where username = 'jivka')),
	((select id from job_ads where title = 'Java Developer'), (select id from users where username = 'jivka'));


SELECT username, fullname, ja.title AS Job, s.from_value AS 'From Value', s.to_value AS 'To Value' FROM job_ad_applications AS jas
JOIN users AS u
	ON jas.user_id = u.id
JOIN  job_ads AS ja
	ON ja.id = jas.job_ad_id
JOIN salaries AS s
	ON ja.salary_id = s.id
ORDER BY username, ja.title ASC 
















SELECT * FROM job_ads