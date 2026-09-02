output "ai_services_cognitive_account_id" {
  value       = length(module.ai_services) == 0 ? null : module.ai_services[0].cognitive_account_id
  description = "ID of the plum AI Services cognitive account (sandbox only; null elsewhere)."
}

output "ai_services_cognitive_account_endpoint" {
  value       = length(module.ai_services) == 0 ? null : one(module.ai_services[0].cognitive_account_endpoint)
  description = "Endpoint of the plum AI Services cognitive account (sandbox only; null elsewhere)."
}

output "document_intelligence_cognitive_account_id" {
  value       = length(module.document_intelligence) == 0 ? null : module.document_intelligence[0].cognitive_account_id
  description = "ID of the crumble Document Intelligence cognitive account (sandbox only; null elsewhere)."
}

output "document_intelligence_cognitive_account_endpoint" {
  value       = length(module.document_intelligence) == 0 ? null : one(module.document_intelligence[0].cognitive_account_endpoint)
  description = "Endpoint of the crumble Document Intelligence cognitive account (sandbox only; null elsewhere)."
}
