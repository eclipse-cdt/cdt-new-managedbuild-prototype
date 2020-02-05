package org.eclipse.cdt.build.managed.ide;

import org.eclipse.emf.common.util.URI;
import org.eclipse.xtext.parser.IEncodingProvider;
import org.eclipse.xtext.resource.IResourceDescription.Manager;
import org.eclipse.xtext.resource.IResourceServiceProvider;
import org.eclipse.xtext.validation.IResourceValidator;

public class ResourceServiceProvider1 implements IResourceServiceProvider {

	public ResourceServiceProvider1() {
		// TODO Auto-generated constructor stub
	}

	@Override
	public IResourceValidator getResourceValidator() {
		// TODO Auto-generated method stub
		return IResourceValidator.NULL;
	}

	@Override
	public Manager getResourceDescriptionManager() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public org.eclipse.xtext.resource.IContainer.Manager getContainerManager() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean canHandle(URI uri) {
		// TODO Auto-generated method stub
		if("cdt".equals(uri.scheme())) {
			return true;
		}
		return false;
	}

	@Override
	public IEncodingProvider getEncodingProvider() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public <T> T get(Class<T> t) {
		// TODO Auto-generated method stub
		return null;
	}

}
