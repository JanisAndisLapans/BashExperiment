CREATE TABLE js_modules (
  name   TEXT PRIMARY KEY,
  source TEXT NOT NULL
);

create table ExperimentResults (
    id serial primary key,
    experiment_name varchar(100),
    problem_name varchar(400),
    problem_desc text,
    problem_category varchar(200),
    problem_complexity int,
    attempt int,
    generated_code text,
    code_complexity decimal,
    tokens_used int,
    ms_to_generate decimal,
    temperature decimal,
    topp decimal,
    model_name varchar(200),
    case_name varchar(400),
    case_complexity int,
    error text,
    is_correct boolean,
    result text,
    sh_style_cnt int,
    sh_info_cnt int,
    sh_warning_cnt int,
    sh_error_cnt int,
    sh_output text,
    score decimal,
    mistake_reason varchar(50),
    type varchar(100)
);