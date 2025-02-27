create table ExperimentResults (
    id serial primary key,
    experiment_name varchar(100),
    problem_name varchar(400),
	problem_category varchar(200),
    problem_complexity int,
    attempt int,
    generated_code text,
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
    score decimal
);