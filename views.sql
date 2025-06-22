-- 請假記錄總覽視圖
CREATE VIEW LeaveSummary AS
SELECT 
  s.student_id,
  s.name AS student_name,
  c.course_name,
  l.leave_date,
  l.reason,
  l.status,
  l.review_time
FROM LeaveRequest l
JOIN Student s ON l.student_id = s.student_id
JOIN Course c ON l.course_id = c.course_id;

-- 課程出席率總表視圖
CREATE VIEW CourseAttendanceRate AS
SELECT 
  c.course_id,
  c.course_name,
  COUNT(a.attendance_id) AS total_records,
  SUM(CASE WHEN a.status = '出席' THEN 1 ELSE 0 END) AS attended,
  ROUND(
    SUM(CASE WHEN a.status = '出席' THEN 1 ELSE 0 END) / COUNT(a.attendance_id) * 100,
    2
  ) AS attendance_rate
FROM Attendance a
JOIN Course c ON a.course_id = c.course_id
GROUP BY c.course_id, c.course_name;
