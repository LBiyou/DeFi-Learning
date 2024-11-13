// Code generated by mockery v2.46.3. DO NOT EDIT.

package mocks

import (
	context "context"

	mock "github.com/stretchr/testify/mock"

	p2pkey "github.com/smartcontractkit/chainlink/v2/core/services/keystore/keys/p2pkey"
)

// P2P is an autogenerated mock type for the P2P type
type P2P struct {
	mock.Mock
}

type P2P_Expecter struct {
	mock *mock.Mock
}

func (_m *P2P) EXPECT() *P2P_Expecter {
	return &P2P_Expecter{mock: &_m.Mock}
}

// Add provides a mock function with given fields: ctx, key
func (_m *P2P) Add(ctx context.Context, key p2pkey.KeyV2) error {
	ret := _m.Called(ctx, key)

	if len(ret) == 0 {
		panic("no return value specified for Add")
	}

	var r0 error
	if rf, ok := ret.Get(0).(func(context.Context, p2pkey.KeyV2) error); ok {
		r0 = rf(ctx, key)
	} else {
		r0 = ret.Error(0)
	}

	return r0
}

// P2P_Add_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'Add'
type P2P_Add_Call struct {
	*mock.Call
}

// Add is a helper method to define mock.On call
//   - ctx context.Context
//   - key p2pkey.KeyV2
func (_e *P2P_Expecter) Add(ctx interface{}, key interface{}) *P2P_Add_Call {
	return &P2P_Add_Call{Call: _e.mock.On("Add", ctx, key)}
}

func (_c *P2P_Add_Call) Run(run func(ctx context.Context, key p2pkey.KeyV2)) *P2P_Add_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run(args[0].(context.Context), args[1].(p2pkey.KeyV2))
	})
	return _c
}

func (_c *P2P_Add_Call) Return(_a0 error) *P2P_Add_Call {
	_c.Call.Return(_a0)
	return _c
}

func (_c *P2P_Add_Call) RunAndReturn(run func(context.Context, p2pkey.KeyV2) error) *P2P_Add_Call {
	_c.Call.Return(run)
	return _c
}

// Create provides a mock function with given fields: ctx
func (_m *P2P) Create(ctx context.Context) (p2pkey.KeyV2, error) {
	ret := _m.Called(ctx)

	if len(ret) == 0 {
		panic("no return value specified for Create")
	}

	var r0 p2pkey.KeyV2
	var r1 error
	if rf, ok := ret.Get(0).(func(context.Context) (p2pkey.KeyV2, error)); ok {
		return rf(ctx)
	}
	if rf, ok := ret.Get(0).(func(context.Context) p2pkey.KeyV2); ok {
		r0 = rf(ctx)
	} else {
		r0 = ret.Get(0).(p2pkey.KeyV2)
	}

	if rf, ok := ret.Get(1).(func(context.Context) error); ok {
		r1 = rf(ctx)
	} else {
		r1 = ret.Error(1)
	}

	return r0, r1
}

// P2P_Create_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'Create'
type P2P_Create_Call struct {
	*mock.Call
}

// Create is a helper method to define mock.On call
//   - ctx context.Context
func (_e *P2P_Expecter) Create(ctx interface{}) *P2P_Create_Call {
	return &P2P_Create_Call{Call: _e.mock.On("Create", ctx)}
}

func (_c *P2P_Create_Call) Run(run func(ctx context.Context)) *P2P_Create_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run(args[0].(context.Context))
	})
	return _c
}

func (_c *P2P_Create_Call) Return(_a0 p2pkey.KeyV2, _a1 error) *P2P_Create_Call {
	_c.Call.Return(_a0, _a1)
	return _c
}

func (_c *P2P_Create_Call) RunAndReturn(run func(context.Context) (p2pkey.KeyV2, error)) *P2P_Create_Call {
	_c.Call.Return(run)
	return _c
}

// Delete provides a mock function with given fields: ctx, id
func (_m *P2P) Delete(ctx context.Context, id p2pkey.PeerID) (p2pkey.KeyV2, error) {
	ret := _m.Called(ctx, id)

	if len(ret) == 0 {
		panic("no return value specified for Delete")
	}

	var r0 p2pkey.KeyV2
	var r1 error
	if rf, ok := ret.Get(0).(func(context.Context, p2pkey.PeerID) (p2pkey.KeyV2, error)); ok {
		return rf(ctx, id)
	}
	if rf, ok := ret.Get(0).(func(context.Context, p2pkey.PeerID) p2pkey.KeyV2); ok {
		r0 = rf(ctx, id)
	} else {
		r0 = ret.Get(0).(p2pkey.KeyV2)
	}

	if rf, ok := ret.Get(1).(func(context.Context, p2pkey.PeerID) error); ok {
		r1 = rf(ctx, id)
	} else {
		r1 = ret.Error(1)
	}

	return r0, r1
}

// P2P_Delete_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'Delete'
type P2P_Delete_Call struct {
	*mock.Call
}

// Delete is a helper method to define mock.On call
//   - ctx context.Context
//   - id p2pkey.PeerID
func (_e *P2P_Expecter) Delete(ctx interface{}, id interface{}) *P2P_Delete_Call {
	return &P2P_Delete_Call{Call: _e.mock.On("Delete", ctx, id)}
}

func (_c *P2P_Delete_Call) Run(run func(ctx context.Context, id p2pkey.PeerID)) *P2P_Delete_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run(args[0].(context.Context), args[1].(p2pkey.PeerID))
	})
	return _c
}

func (_c *P2P_Delete_Call) Return(_a0 p2pkey.KeyV2, _a1 error) *P2P_Delete_Call {
	_c.Call.Return(_a0, _a1)
	return _c
}

func (_c *P2P_Delete_Call) RunAndReturn(run func(context.Context, p2pkey.PeerID) (p2pkey.KeyV2, error)) *P2P_Delete_Call {
	_c.Call.Return(run)
	return _c
}

// EnsureKey provides a mock function with given fields: ctx
func (_m *P2P) EnsureKey(ctx context.Context) error {
	ret := _m.Called(ctx)

	if len(ret) == 0 {
		panic("no return value specified for EnsureKey")
	}

	var r0 error
	if rf, ok := ret.Get(0).(func(context.Context) error); ok {
		r0 = rf(ctx)
	} else {
		r0 = ret.Error(0)
	}

	return r0
}

// P2P_EnsureKey_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'EnsureKey'
type P2P_EnsureKey_Call struct {
	*mock.Call
}

// EnsureKey is a helper method to define mock.On call
//   - ctx context.Context
func (_e *P2P_Expecter) EnsureKey(ctx interface{}) *P2P_EnsureKey_Call {
	return &P2P_EnsureKey_Call{Call: _e.mock.On("EnsureKey", ctx)}
}

func (_c *P2P_EnsureKey_Call) Run(run func(ctx context.Context)) *P2P_EnsureKey_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run(args[0].(context.Context))
	})
	return _c
}

func (_c *P2P_EnsureKey_Call) Return(_a0 error) *P2P_EnsureKey_Call {
	_c.Call.Return(_a0)
	return _c
}

func (_c *P2P_EnsureKey_Call) RunAndReturn(run func(context.Context) error) *P2P_EnsureKey_Call {
	_c.Call.Return(run)
	return _c
}

// Export provides a mock function with given fields: id, password
func (_m *P2P) Export(id p2pkey.PeerID, password string) ([]byte, error) {
	ret := _m.Called(id, password)

	if len(ret) == 0 {
		panic("no return value specified for Export")
	}

	var r0 []byte
	var r1 error
	if rf, ok := ret.Get(0).(func(p2pkey.PeerID, string) ([]byte, error)); ok {
		return rf(id, password)
	}
	if rf, ok := ret.Get(0).(func(p2pkey.PeerID, string) []byte); ok {
		r0 = rf(id, password)
	} else {
		if ret.Get(0) != nil {
			r0 = ret.Get(0).([]byte)
		}
	}

	if rf, ok := ret.Get(1).(func(p2pkey.PeerID, string) error); ok {
		r1 = rf(id, password)
	} else {
		r1 = ret.Error(1)
	}

	return r0, r1
}

// P2P_Export_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'Export'
type P2P_Export_Call struct {
	*mock.Call
}

// Export is a helper method to define mock.On call
//   - id p2pkey.PeerID
//   - password string
func (_e *P2P_Expecter) Export(id interface{}, password interface{}) *P2P_Export_Call {
	return &P2P_Export_Call{Call: _e.mock.On("Export", id, password)}
}

func (_c *P2P_Export_Call) Run(run func(id p2pkey.PeerID, password string)) *P2P_Export_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run(args[0].(p2pkey.PeerID), args[1].(string))
	})
	return _c
}

func (_c *P2P_Export_Call) Return(_a0 []byte, _a1 error) *P2P_Export_Call {
	_c.Call.Return(_a0, _a1)
	return _c
}

func (_c *P2P_Export_Call) RunAndReturn(run func(p2pkey.PeerID, string) ([]byte, error)) *P2P_Export_Call {
	_c.Call.Return(run)
	return _c
}

// Get provides a mock function with given fields: id
func (_m *P2P) Get(id p2pkey.PeerID) (p2pkey.KeyV2, error) {
	ret := _m.Called(id)

	if len(ret) == 0 {
		panic("no return value specified for Get")
	}

	var r0 p2pkey.KeyV2
	var r1 error
	if rf, ok := ret.Get(0).(func(p2pkey.PeerID) (p2pkey.KeyV2, error)); ok {
		return rf(id)
	}
	if rf, ok := ret.Get(0).(func(p2pkey.PeerID) p2pkey.KeyV2); ok {
		r0 = rf(id)
	} else {
		r0 = ret.Get(0).(p2pkey.KeyV2)
	}

	if rf, ok := ret.Get(1).(func(p2pkey.PeerID) error); ok {
		r1 = rf(id)
	} else {
		r1 = ret.Error(1)
	}

	return r0, r1
}

// P2P_Get_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'Get'
type P2P_Get_Call struct {
	*mock.Call
}

// Get is a helper method to define mock.On call
//   - id p2pkey.PeerID
func (_e *P2P_Expecter) Get(id interface{}) *P2P_Get_Call {
	return &P2P_Get_Call{Call: _e.mock.On("Get", id)}
}

func (_c *P2P_Get_Call) Run(run func(id p2pkey.PeerID)) *P2P_Get_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run(args[0].(p2pkey.PeerID))
	})
	return _c
}

func (_c *P2P_Get_Call) Return(_a0 p2pkey.KeyV2, _a1 error) *P2P_Get_Call {
	_c.Call.Return(_a0, _a1)
	return _c
}

func (_c *P2P_Get_Call) RunAndReturn(run func(p2pkey.PeerID) (p2pkey.KeyV2, error)) *P2P_Get_Call {
	_c.Call.Return(run)
	return _c
}

// GetAll provides a mock function with given fields:
func (_m *P2P) GetAll() ([]p2pkey.KeyV2, error) {
	ret := _m.Called()

	if len(ret) == 0 {
		panic("no return value specified for GetAll")
	}

	var r0 []p2pkey.KeyV2
	var r1 error
	if rf, ok := ret.Get(0).(func() ([]p2pkey.KeyV2, error)); ok {
		return rf()
	}
	if rf, ok := ret.Get(0).(func() []p2pkey.KeyV2); ok {
		r0 = rf()
	} else {
		if ret.Get(0) != nil {
			r0 = ret.Get(0).([]p2pkey.KeyV2)
		}
	}

	if rf, ok := ret.Get(1).(func() error); ok {
		r1 = rf()
	} else {
		r1 = ret.Error(1)
	}

	return r0, r1
}

// P2P_GetAll_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'GetAll'
type P2P_GetAll_Call struct {
	*mock.Call
}

// GetAll is a helper method to define mock.On call
func (_e *P2P_Expecter) GetAll() *P2P_GetAll_Call {
	return &P2P_GetAll_Call{Call: _e.mock.On("GetAll")}
}

func (_c *P2P_GetAll_Call) Run(run func()) *P2P_GetAll_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run()
	})
	return _c
}

func (_c *P2P_GetAll_Call) Return(_a0 []p2pkey.KeyV2, _a1 error) *P2P_GetAll_Call {
	_c.Call.Return(_a0, _a1)
	return _c
}

func (_c *P2P_GetAll_Call) RunAndReturn(run func() ([]p2pkey.KeyV2, error)) *P2P_GetAll_Call {
	_c.Call.Return(run)
	return _c
}

// GetOrFirst provides a mock function with given fields: id
func (_m *P2P) GetOrFirst(id p2pkey.PeerID) (p2pkey.KeyV2, error) {
	ret := _m.Called(id)

	if len(ret) == 0 {
		panic("no return value specified for GetOrFirst")
	}

	var r0 p2pkey.KeyV2
	var r1 error
	if rf, ok := ret.Get(0).(func(p2pkey.PeerID) (p2pkey.KeyV2, error)); ok {
		return rf(id)
	}
	if rf, ok := ret.Get(0).(func(p2pkey.PeerID) p2pkey.KeyV2); ok {
		r0 = rf(id)
	} else {
		r0 = ret.Get(0).(p2pkey.KeyV2)
	}

	if rf, ok := ret.Get(1).(func(p2pkey.PeerID) error); ok {
		r1 = rf(id)
	} else {
		r1 = ret.Error(1)
	}

	return r0, r1
}

// P2P_GetOrFirst_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'GetOrFirst'
type P2P_GetOrFirst_Call struct {
	*mock.Call
}

// GetOrFirst is a helper method to define mock.On call
//   - id p2pkey.PeerID
func (_e *P2P_Expecter) GetOrFirst(id interface{}) *P2P_GetOrFirst_Call {
	return &P2P_GetOrFirst_Call{Call: _e.mock.On("GetOrFirst", id)}
}

func (_c *P2P_GetOrFirst_Call) Run(run func(id p2pkey.PeerID)) *P2P_GetOrFirst_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run(args[0].(p2pkey.PeerID))
	})
	return _c
}

func (_c *P2P_GetOrFirst_Call) Return(_a0 p2pkey.KeyV2, _a1 error) *P2P_GetOrFirst_Call {
	_c.Call.Return(_a0, _a1)
	return _c
}

func (_c *P2P_GetOrFirst_Call) RunAndReturn(run func(p2pkey.PeerID) (p2pkey.KeyV2, error)) *P2P_GetOrFirst_Call {
	_c.Call.Return(run)
	return _c
}

// Import provides a mock function with given fields: ctx, keyJSON, password
func (_m *P2P) Import(ctx context.Context, keyJSON []byte, password string) (p2pkey.KeyV2, error) {
	ret := _m.Called(ctx, keyJSON, password)

	if len(ret) == 0 {
		panic("no return value specified for Import")
	}

	var r0 p2pkey.KeyV2
	var r1 error
	if rf, ok := ret.Get(0).(func(context.Context, []byte, string) (p2pkey.KeyV2, error)); ok {
		return rf(ctx, keyJSON, password)
	}
	if rf, ok := ret.Get(0).(func(context.Context, []byte, string) p2pkey.KeyV2); ok {
		r0 = rf(ctx, keyJSON, password)
	} else {
		r0 = ret.Get(0).(p2pkey.KeyV2)
	}

	if rf, ok := ret.Get(1).(func(context.Context, []byte, string) error); ok {
		r1 = rf(ctx, keyJSON, password)
	} else {
		r1 = ret.Error(1)
	}

	return r0, r1
}

// P2P_Import_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'Import'
type P2P_Import_Call struct {
	*mock.Call
}

// Import is a helper method to define mock.On call
//   - ctx context.Context
//   - keyJSON []byte
//   - password string
func (_e *P2P_Expecter) Import(ctx interface{}, keyJSON interface{}, password interface{}) *P2P_Import_Call {
	return &P2P_Import_Call{Call: _e.mock.On("Import", ctx, keyJSON, password)}
}

func (_c *P2P_Import_Call) Run(run func(ctx context.Context, keyJSON []byte, password string)) *P2P_Import_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run(args[0].(context.Context), args[1].([]byte), args[2].(string))
	})
	return _c
}

func (_c *P2P_Import_Call) Return(_a0 p2pkey.KeyV2, _a1 error) *P2P_Import_Call {
	_c.Call.Return(_a0, _a1)
	return _c
}

func (_c *P2P_Import_Call) RunAndReturn(run func(context.Context, []byte, string) (p2pkey.KeyV2, error)) *P2P_Import_Call {
	_c.Call.Return(run)
	return _c
}

// NewP2P creates a new instance of P2P. It also registers a testing interface on the mock and a cleanup function to assert the mocks expectations.
// The first argument is typically a *testing.T value.
func NewP2P(t interface {
	mock.TestingT
	Cleanup(func())
}) *P2P {
	mock := &P2P{}
	mock.Mock.Test(t)

	t.Cleanup(func() { mock.AssertExpectations(t) })

	return mock
}
