package org.davromalc.tutorial.controller;

import java.util.List;

import org.davromalc.tutorial.model.Customer;
import org.davromalc.tutorial.repository.CustomerRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
public class CustomerRestController {
	private static final Logger LOGGER = LoggerFactory.getLogger(CustomerRestController.class);
	
	@Autowired
	private CustomerRepository repository;
	
	@RequestMapping("customer/")
	public List<Customer> findAll(){
		final List<Customer> customers = repository.findAll();
		LOGGER.info("Fetching customers from database {}" , customers);
		return customers;
	}
	
	@RequestMapping("customer/first/{firstName}")
	public Customer findByFirstName(@PathVariable("firstName") String firstName){
		final Customer customer = repository.findByFirstName(firstName);
		LOGGER.info("Fetching customers from database {}" , customer);
		return customer;
	}
	
	@RequestMapping("customer/last/{lastName}")
	public List<Customer> findByLastName(@PathVariable("lastName") String lastName){
		final List<Customer> customer = repository.findByLastName(lastName);
		LOGGER.info("Fetching customers from database {}" , customer);
		return customer;
	}
	
	@RequestMapping("customer/cn/{country}")
	public List<Customer> findByCountry(@PathVariable("country") String country){
		final List<Customer> customer = repository.findByLastName(country);
		LOGGER.info("Fetching customers from database {}" , customer);
		return customer;
	}
	
	@RequestMapping(value = "customer/" , method = RequestMethod.POST)
	public void save(@RequestBody Customer customer){
		LOGGER.info("Storing customer in database {}", customer);
		repository.save(customer);
	}
	
}
