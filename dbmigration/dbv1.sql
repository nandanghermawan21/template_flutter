CREATE TABLE todo (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT,
  due_date DATE,
  is_completed BOOLEAN DEFAULT 0
);