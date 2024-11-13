// Code generated by mockery v2.46.3. DO NOT EDIT.

package headreporter

import (
	context "context"

	types "github.com/smartcontractkit/chainlink/v2/core/chains/evm/types"
	mock "github.com/stretchr/testify/mock"
)

// MockHeadReporter is an autogenerated mock type for the HeadReporter type
type MockHeadReporter struct {
	mock.Mock
}

type MockHeadReporter_Expecter struct {
	mock *mock.Mock
}

func (_m *MockHeadReporter) EXPECT() *MockHeadReporter_Expecter {
	return &MockHeadReporter_Expecter{mock: &_m.Mock}
}

// ReportNewHead provides a mock function with given fields: ctx, head
func (_m *MockHeadReporter) ReportNewHead(ctx context.Context, head *types.Head) error {
	ret := _m.Called(ctx, head)

	if len(ret) == 0 {
		panic("no return value specified for ReportNewHead")
	}

	var r0 error
	if rf, ok := ret.Get(0).(func(context.Context, *types.Head) error); ok {
		r0 = rf(ctx, head)
	} else {
		r0 = ret.Error(0)
	}

	return r0
}

// MockHeadReporter_ReportNewHead_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'ReportNewHead'
type MockHeadReporter_ReportNewHead_Call struct {
	*mock.Call
}

// ReportNewHead is a helper method to define mock.On call
//   - ctx context.Context
//   - head *types.Head
func (_e *MockHeadReporter_Expecter) ReportNewHead(ctx interface{}, head interface{}) *MockHeadReporter_ReportNewHead_Call {
	return &MockHeadReporter_ReportNewHead_Call{Call: _e.mock.On("ReportNewHead", ctx, head)}
}

func (_c *MockHeadReporter_ReportNewHead_Call) Run(run func(ctx context.Context, head *types.Head)) *MockHeadReporter_ReportNewHead_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run(args[0].(context.Context), args[1].(*types.Head))
	})
	return _c
}

func (_c *MockHeadReporter_ReportNewHead_Call) Return(_a0 error) *MockHeadReporter_ReportNewHead_Call {
	_c.Call.Return(_a0)
	return _c
}

func (_c *MockHeadReporter_ReportNewHead_Call) RunAndReturn(run func(context.Context, *types.Head) error) *MockHeadReporter_ReportNewHead_Call {
	_c.Call.Return(run)
	return _c
}

// ReportPeriodic provides a mock function with given fields: ctx
func (_m *MockHeadReporter) ReportPeriodic(ctx context.Context) error {
	ret := _m.Called(ctx)

	if len(ret) == 0 {
		panic("no return value specified for ReportPeriodic")
	}

	var r0 error
	if rf, ok := ret.Get(0).(func(context.Context) error); ok {
		r0 = rf(ctx)
	} else {
		r0 = ret.Error(0)
	}

	return r0
}

// MockHeadReporter_ReportPeriodic_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'ReportPeriodic'
type MockHeadReporter_ReportPeriodic_Call struct {
	*mock.Call
}

// ReportPeriodic is a helper method to define mock.On call
//   - ctx context.Context
func (_e *MockHeadReporter_Expecter) ReportPeriodic(ctx interface{}) *MockHeadReporter_ReportPeriodic_Call {
	return &MockHeadReporter_ReportPeriodic_Call{Call: _e.mock.On("ReportPeriodic", ctx)}
}

func (_c *MockHeadReporter_ReportPeriodic_Call) Run(run func(ctx context.Context)) *MockHeadReporter_ReportPeriodic_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run(args[0].(context.Context))
	})
	return _c
}

func (_c *MockHeadReporter_ReportPeriodic_Call) Return(_a0 error) *MockHeadReporter_ReportPeriodic_Call {
	_c.Call.Return(_a0)
	return _c
}

func (_c *MockHeadReporter_ReportPeriodic_Call) RunAndReturn(run func(context.Context) error) *MockHeadReporter_ReportPeriodic_Call {
	_c.Call.Return(run)
	return _c
}

// NewMockHeadReporter creates a new instance of MockHeadReporter. It also registers a testing interface on the mock and a cleanup function to assert the mocks expectations.
// The first argument is typically a *testing.T value.
func NewMockHeadReporter(t interface {
	mock.TestingT
	Cleanup(func())
}) *MockHeadReporter {
	mock := &MockHeadReporter{}
	mock.Mock.Test(t)

	t.Cleanup(func() { mock.AssertExpectations(t) })

	return mock
}
