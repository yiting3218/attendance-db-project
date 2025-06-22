-- 1. 插入請假資料時，自動記錄處理時間
DELIMITER //

CREATE TRIGGER trg_insert_leave
BEFORE INSERT ON LeaveRequest
FOR EACH ROW
BEGIN
  SET NEW.status = '待審核';
END;
//

-- 2. 更新請假審核狀態時，自動記錄審核時間（需要欄位 review_time）
CREATE TRIGGER trg_update_review_time
BEFORE UPDATE ON LeaveRequest
FOR EACH ROW
BEGIN
  IF NEW.status <> OLD.status THEN
    SET NEW.review_time = NOW();
  END IF;
END;
//

-- 3. 刪除出席紀錄時，將其備份至 Log 表
CREATE TRIGGER trg_backup_attendance
BEFORE DELETE ON Attendance
FOR EACH ROW
BEGIN
  INSERT INTO AttendanceLog (student_id, course_id, attendance_date, status, deleted_at)
  VALUES (OLD.student_id, OLD.course_id, OLD.attendance_date, OLD.status, NOW());
END;
//

DELIMITER ;
