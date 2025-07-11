-- ===================================================================
-- SEED DATA CON LOS UUIDs PROPORCIONADOS
-- ===================================================================

-- 1. USUARIOS (con contraseñas hasheadas bcrypt)
INSERT INTO users (
  id, email, name, role, password_hash, 
  avatar, bio, website, location, phone, 
  birth_date, is_active, email_verified, last_login, created_at
) VALUES
-- Administrador
(
  'bf20ed23-7935-447b-94d0-9777d13142c2', 
  'admin@learning.com', 
  'Admin Principal', 
  'admin', 
  crypt('admin123', gen_salt('bf')),
  'https://example.com/avatars/admin.jpg',
  'Administrador principal de la plataforma',
  'https://learning.com',
  'Ciudad de México',
  '+525512345678',
  '1980-01-15',
  TRUE,
  TRUE,
  NOW() - INTERVAL '1 day',
  NOW() - INTERVAL '1 year'
),

-- Instructor
(
  '58b37053-7fcd-4736-9c4a-f41127a4ec7b', 
  'instructor@learning.com', 
  'Profesor React', 
  'instructor', 
  crypt('profesor1', gen_salt('bf')),
  'https://example.com/avatars/instructor1.jpg',
  'Instructor especializado en desarrollo frontend con 10 años de experiencia',
  'https://profesor-react.com',
  'Bogotá, Colombia',
  '+571234567890',
  '1985-05-20',
  TRUE,
  TRUE,
  NOW() - INTERVAL '3 hours',
  NOW() - INTERVAL '6 months'
),

-- Estudiante 1
(
  '90cd77cd-0b15-4213-9004-9678b6791f87', 
  'estudiante1@learning.com', 
  'María Estudiante', 
  'student', 
  crypt('estudiante1', gen_salt('bf')),
  'https://example.com/avatars/student1.jpg',
  'Estudiante de ingeniería de sistemas apasionada por el desarrollo web',
  NULL,
  'Medellín, Colombia',
  '+574567890123',
  '1995-08-10',
  TRUE,
  TRUE,
  NOW() - INTERVAL '2 hours',
  NOW() - INTERVAL '3 months'
),

-- Estudiante 2
(
  '1ea16d92-f1f4-4ac1-9f1e-cd1c423432f6', 
  'estudiante2@learning.com', 
  'Carlos Aprendiz', 
  'student', 
  crypt('estudiante2', gen_salt('bf')),
  NULL,
  'Analista de datos aprendiendo SQL y Python',
  'https://carlos-analytics.com',
  'Lima, Perú',
  '+51987654321',
  '1990-11-25',
  TRUE,
  FALSE,
  NOW() - INTERVAL '5 days',
  NOW() - INTERVAL '2 months'
);
INSERT INTO categories (id, name, slug, color, icon, description) VALUES
('ae6d734c-7e3b-48b2-a5af-4969e91ef07c', 'Programación', 'programacion', '#34d399', 'code', 'Cursos de desarrollo de software'),
('dd99d336-0e35-440c-8229-23dc0a67157e', 'Ciencia de Datos', 'ciencia-datos', '#3b82f6', 'database', 'Análisis y visualización de datos'),
('0f89fe27-d3ff-42b8-bc82-6c1088f50c86', 'Diseño', 'diseno', '#a855f7', 'palette', 'Diseño UI/UX y gráfico');

INSERT INTO courses (id, title, description, author_id, category_id, status, level, price, is_featured, tags) VALUES
('6de9ad66-c0df-45a6-9514-77d058d27f9a', 'React Avanzado', 'Aprende hooks, context API y patrones avanzados', '58b37053-7fcd-4736-9c4a-f41127a4ec7b', 'ae6d734c-7e3b-48b2-a5af-4969e91ef07c', 'published', 'advanced', 19900, TRUE, '{"react","frontend","javascript"}'),
('e35c3834-6c0a-4f8f-a76b-3d921e5547d5', 'SQL para Analistas', 'Domina consultas complejas y optimización', '58b37053-7fcd-4736-9c4a-f41127a4ec7b', 'dd99d336-0e35-440c-8229-23dc0a67157e', 'published', 'intermediate', 14900, FALSE, '{"sql","data","analytics"}'),
('f5a25cd3-8090-4c7b-a62c-db348b236680', 'Diseño de Interfaces', 'Principios de UI/UX moderno', '58b37053-7fcd-4736-9c4a-f41127a4ec7b', '0f89fe27-d3ff-42b8-bc82-6c1088f50c86', 'published', 'beginner', 24900, TRUE, '{"design","ui","ux"}');

INSERT INTO lessons (id, course_id, title, order_index, duration, is_published) VALUES
-- Curso React
('737bce04-3e87-454a-905b-b7e4ba65334b', '6de9ad66-c0df-45a6-9514-77d058d27f9a', 'Introducción a Hooks', 1, 30, TRUE),
('00f1b645-d3ae-421c-ab7b-fc03e5a69bde', '6de9ad66-c0df-45a6-9514-77d058d27f9a', 'useEffect en profundidad', 2, 45, TRUE),
('a57f5ed3-ad93-4098-89a0-22b7b910d104', '6de9ad66-c0df-45a6-9514-77d058d27f9a', 'Context API', 3, 35, TRUE),

-- Curso SQL
('5af2ffb9-3a7c-4159-b1d8-92ec6f0edcb2', 'e35c3834-6c0a-4f8f-a76b-3d921e5547d5', 'Consultas JOIN', 1, 40, TRUE),
('5fabafd4-74cc-4957-879b-41b44b9a8cdd', 'e35c3834-6c0a-4f8f-a76b-3d921e5547d5', 'Subconsultas', 2, 35, TRUE),

-- Curso Diseño
('cfd7afa1-2be6-4585-bb03-5a42183987d3', 'f5a25cd3-8090-4c7b-a62c-db348b236680', 'Teoría del Color', 1, 25, TRUE),
('46643057-c272-4d0c-9973-17ddd8b570aa', 'f5a25cd3-8090-4c7b-a62c-db348b236680', 'Tipografía', 2, 30, TRUE);

INSERT INTO enrollments (id, user_id, course_id, progress, enrolled_at) VALUES
('72b63a2f-15df-491b-9f4e-808546a098e8', '90cd77cd-0b15-4213-9004-9678b6791f87', '6de9ad66-c0df-45a6-9514-77d058d27f9a', 65, NOW() - INTERVAL '10 days'),
('1adb2b85-97b9-4ec7-954c-4d37754bd65c', '1ea16d92-f1f4-4ac1-9f1e-cd1c423432f6', 'e35c3834-6c0a-4f8f-a76b-3d921e5547d5', 40, NOW() - INTERVAL '5 days'),
('9e865df8-50f8-478f-b838-407180c2ddcb', '90cd77cd-0b15-4213-9004-9678b6791f87', 'f5a25cd3-8090-4c7b-a62c-db348b236680', 15, NOW() - INTERVAL '2 days');

INSERT INTO lesson_progress (id, user_id, lesson_id, completed, watch_time, completed_at) VALUES
('682aaffe-f1ba-4987-9200-d57cd4bff1b5', '90cd77cd-0b15-4213-9004-9678b6791f87', '737bce04-3e87-454a-905b-b7e4ba65334b', TRUE, 1800, NOW() - INTERVAL '8 days'),
('d05a96fc-4369-41dd-9c79-5956a139a14a', '90cd77cd-0b15-4213-9004-9678b6791f87', '00f1b645-d3ae-421c-ab7b-fc03e5a69bde', TRUE, 2700, NOW() - INTERVAL '5 days'),
('30803903-c83c-45fd-bce3-951ea2023483', '1ea16d92-f1f4-4ac1-9f1e-cd1c423432f6', '5af2ffb9-3a7c-4159-b1d8-92ec6f0edcb2', FALSE, 1500, NULL);

INSERT INTO comments (id, user_id, course_id, content, likes_count) VALUES
('90e6a2ab-320e-4360-bb09-b05feb21a75f', '90cd77cd-0b15-4213-9004-9678b6791f87', '6de9ad66-c0df-45a6-9514-77d058d27f9a', 'Excelente explicación de los hooks, muy claro', 2),
('8766e03b-3e97-4954-8ee7-ff1eb79db493', '1ea16d92-f1f4-4ac1-9f1e-cd1c423432f6', 'e35c3834-6c0a-4f8f-a76b-3d921e5547d5', '¿Alguien tiene ejemplos prácticos de subconsultas?', 0);

INSERT INTO comment_likes (id, user_id, comment_id) VALUES
('44b5e3fa-47c2-4716-8cd2-8d195bc8735e', '1ea16d92-f1f4-4ac1-9f1e-cd1c423432f6', '90e6a2ab-320e-4360-bb09-b05feb21a75f'),
('6bbcc064-6ddb-4d8e-a6a3-76a84496630a', '58b37053-7fcd-4736-9c4a-f41127a4ec7b', '90e6a2ab-320e-4360-bb09-b05feb21a75f');

INSERT INTO ratings (id, user_id, course_id, rating, review) VALUES
('850d86c4-bca6-49e7-868d-69e40c3321be', '90cd77cd-0b15-4213-9004-9678b6791f87', '6de9ad66-c0df-45a6-9514-77d058d27f9a', 5, 'El mejor curso de React que he tomado'),
('847887a1-423d-4b77-9c1d-48776e6ee66c', '1ea16d92-f1f4-4ac1-9f1e-cd1c423432f6', 'e35c3834-6c0a-4f8f-a76b-3d921e5547d5', 4, 'Buen contenido pero necesita más ejercicios');

INSERT INTO quizzes (id, course_id, title, max_attempts, passing_score) VALUES
('e2b78cd9-b081-4eac-bf93-bb4f182d7328', '6de9ad66-c0df-45a6-9514-77d058d27f9a', 'Evaluación React Hooks', 3, 70);

INSERT INTO quiz_questions (id, quiz_id, question, question_type, points, order_index) VALUES
('d8abb3f1-76b6-4e87-8779-5edcaa40e189', 'e2b78cd9-b081-4eac-bf93-bb4f182d7328', '¿Qué hook se usa para efectos secundarios?', 'multiple_choice', 2, 1),
('bfbe6682-fab2-432c-b279-e35aafffaeb4', 'e2b78cd9-b081-4eac-bf93-bb4f182d7328', 'useMemo optimiza el rendimiento', 'true_false', 1, 2);

INSERT INTO quiz_options (id, question_id, option_text, is_correct, order_index) VALUES
-- Opciones para pregunta 1
('ee38d54c-06e2-4d30-a7cd-dbb49ea9f904', 'd8abb3f1-76b6-4e87-8779-5edcaa40e189', 'useEffect', TRUE, 1),
('1e74acfe-3f19-4570-951e-9c6f64509398', 'd8abb3f1-76b6-4e87-8779-5edcaa40e189', 'useState', FALSE, 2),
('9c4fea33-beac-47d4-abc0-26eacfbe76cc', 'd8abb3f1-76b6-4e87-8779-5edcaa40e189', 'useContext', FALSE, 3),

-- Opciones para pregunta 2 (true/false)
('f4960c77-2933-4671-9090-2737e0b81005', 'bfbe6682-fab2-432c-b279-e35aafffaeb4', 'Verdadero', TRUE, 1),
('88ebbe6c-df14-4102-95ba-3e6dbd1a85b1', 'bfbe6682-fab2-432c-b279-e35aafffaeb4', 'Falso', FALSE, 2);

INSERT INTO quiz_attempts (id, quiz_id, user_id, attempt_no, started_at) VALUES
('16d6ae74-6159-4461-9328-edf57b38ed40', 'e2b78cd9-b081-4eac-bf93-bb4f182d7328', '90cd77cd-0b15-4213-9004-9678b6791f87', 1, NOW() - INTERVAL '1 hour');

INSERT INTO quiz_user_answers (id, attempt_id, question_id, selected_option_id) VALUES
('b304d1f4-165b-4be4-942f-333ef0f86754', '16d6ae74-6159-4461-9328-edf57b38ed40', 'd8abb3f1-76b6-4e87-8779-5edcaa40e189', 'ee38d54c-06e2-4d30-a7cd-dbb49ea9f904'),
('77b1a743-2ed7-4dc1-a935-1b41383a0dfe', '16d6ae74-6159-4461-9328-edf57b38ed40', 'bfbe6682-fab2-432c-b279-e35aafffaeb4', 'f4960c77-2933-4671-9090-2737e0b81005');

-- Calcular puntuación del intento
SELECT calculate_quiz_score('16d6ae74-6159-4461-9328-edf57b38ed40');

INSERT INTO certificates (id, user_id, course_id, certificate_number, verification_code, final_score) VALUES
('1463bbef-99cd-43bd-93bc-7f767de4f3f6', '90cd77cd-0b15-4213-9004-9678b6791f87', '6de9ad66-c0df-45a6-9514-77d058d27f9a', 'CERT-REACT-001', 'VER-CODE-001', 92);

INSERT INTO user_activity (id, user_id, activity_type, activity_data) VALUES
('b0b40099-9ba7-402d-bade-26fd82ad9d7d', '90cd77cd-0b15-4213-9004-9678b6791f87', 'course_started', '{"course_id": "6de9ad66-c0df-45a6-9514-77d058d27f9a", "course_title": "React Avanzado"}'),
('59cd134c-3706-493c-9217-1109b1a0816d', '1ea16d92-f1f4-4ac1-9f1e-cd1c423432f6', 'lesson_completed', '{"lesson_id": "5af2ffb9-3a7c-4159-b1d8-92ec6f0edcb2", "lesson_title": "Consultas JOIN"}');

INSERT INTO notifications (id, user_id, title, message, type) VALUES
('73785b0b-524e-49fc-9f9c-10b5724e7666', '90cd77cd-0b15-4213-9004-9678b6791f87', 'Nuevo comentario', 'Tienes una nueva respuesta a tu comentario', 'info'),
('4c0459c6-5856-4f64-bc93-03b97fb57f4c', '1ea16d92-f1f4-4ac1-9f1e-cd1c423432f6', 'Curso completado', '¡Felicidades por completar el curso!', 'success');