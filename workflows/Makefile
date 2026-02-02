SHELL := /bin/bash
BATS_VERSION := v1.10.0
BATS_SUPPORT_VERSION := v0.3.0
BATS_ASSERT_VERSION := v2.1.0

TEST_DIR := test
BATS_LIBS_DIR := $(TEST_DIR)/.bats

ALL_TESTS := $(wildcard $(TEST_DIR)/**/*.bats) $(wildcard $(TEST_DIR)/*.bats)

.PHONY: test setup-bats

test: setup-bats
	@echo "Running all workflow tests..."
	@$(BATS_LIBS_DIR)/bats-core/bin/bats $(ALL_TESTS)

setup-bats:
	@echo "Setting up BATS testing framework..."
	@mkdir -p $(BATS_LIBS_DIR)

	@if [ ! -d "$(BATS_LIBS_DIR)/bats-core" ]; then \
		git clone https://github.com/bats-core/bats-core.git $(BATS_LIBS_DIR)/bats-core --branch $(BATS_VERSION) --depth 1; \
	fi

	@if [ ! -d "$(BATS_LIBS_DIR)/bats-support" ]; then \
		git clone https://github.com/bats-core/bats-support.git $(BATS_LIBS_DIR)/bats-support --branch $(BATS_SUPPORT_VERSION) --depth 1; \
	fi

	@if [ ! -d "$(BATS_LIBS_DIR)/bats-assert" ]; then \
		git clone https://github.com/bats-core/bats-assert.git $(BATS_LIBS_DIR)/bats-assert --branch $(BATS_ASSERT_VERSION) --depth 1; \
	fi

	@echo "BATS setup complete!"
