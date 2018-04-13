/* https://github.com/AdrianEddy/AIMPYouTube/blob/master/IUnknownInterfaceImpl.h */

template <typename T>
class IUnknownInterfaceImpl : public T
{
public:
	IUnknownInterfaceImpl()
		: reference_count_(0)
	{}

	virtual ~IUnknownInterfaceImpl() {}

	virtual HRESULT WINAPI QueryInterface(REFIID riid, LPVOID* ppvObj)
	{
		if (!ppvObj)
		{
			return E_POINTER;
		}

		if (IID_IUnknown == riid)
		{
			*ppvObj = this;
			AddRef();
			return S_OK;
		}

		return E_NOINTERFACE;
	}

	virtual ULONG WINAPI AddRef(void)
	{
		return ++reference_count_;
	}

	virtual ULONG WINAPI Release(void) {
		ULONG reference_count = --reference_count_;

		if (reference_count == 0)
		{
			delete this;
		}

		return reference_count;
	}

private:
	ULONG reference_count_;
};