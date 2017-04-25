#!/usr/bin/env bats

load '/usr/local/lib/bats-support/load.bash'
load '/usr/local/lib/bats-assert/load.bash'
load '../lib/shared'

@test "Read docker-compose config when none exists" {
  run docker_compose_config_files

  assert_success
  assert_output "docker-compose.yml"
}

@test "Read the first docker-compose config when none exists" {
  run docker_compose_config_file

  assert_success
  assert_output "docker-compose.yml"
}

@test "Read docker-compose config when there are several" {
  export BUILDKITE_PLUGIN_DOCKER_COMPOSE_CONFIG_0="llamas1.yml"
  export BUILDKITE_PLUGIN_DOCKER_COMPOSE_CONFIG_1="llamas2.yml"
  export BUILDKITE_PLUGIN_DOCKER_COMPOSE_CONFIG_2="llamas3.yml"
  run docker_compose_config_files

  assert_success
  assert_equal "${lines[0]}" "llamas1.yml"
  assert_equal "${lines[1]}" "llamas2.yml"
  assert_equal "${lines[2]}" "llamas3.yml"
}

@test "Read the first docker-compose config when there are several" {
  export BUILDKITE_PLUGIN_DOCKER_COMPOSE_CONFIG_0="llamas1.yml"
  export BUILDKITE_PLUGIN_DOCKER_COMPOSE_CONFIG_1="llamas2.yml"
  export BUILDKITE_PLUGIN_DOCKER_COMPOSE_CONFIG_2="llamas3.yml"
  run docker_compose_config_file

  assert_success
  assert_output "llamas1.yml"
}

@test "Read colon delimited config files" {
  export BUILDKITE_PLUGIN_DOCKER_COMPOSE_CONFIG="llamas1.yml:llamas2.yml"
  run docker_compose_config_files

  assert_success
  assert_equal "${lines[0]}" "llamas1.yml"
  assert_equal "${lines[1]}" "llamas2.yml"
}

@test "Read the first docker-compose config when there are colon delimited config files" {
  export BUILDKITE_PLUGIN_DOCKER_COMPOSE_CONFIG="llamas1.yml:llamas2.yml"
  run docker_compose_config_file

  assert_success
  assert_output "llamas1.yml"
}

@test "Read version from docker-compose v2 file" {
  export BUILDKITE_PLUGIN_DOCKER_COMPOSE_CONFIG="tests/composefiles/docker-compose.v2.0.yml"
  run docker_compose_config_version
  assert_success
  assert_output "2"
}

@test "Read version from docker-compose v2.1 file" {
  export BUILDKITE_PLUGIN_DOCKER_COMPOSE_CONFIG="tests/composefiles/docker-compose.v2.1.yml"
  run docker_compose_config_version
  assert_success
  assert_output "2.1"
}
